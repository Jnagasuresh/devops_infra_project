

# Create a VPC
resource "google_compute_network" "tf-vpc" {
 name = var.vpc_name
 auto_create_subnetworks = false
}

# Create a subnet in us-central
resource "google_compute_subnetwork" "tf-subnet" {
  name = "${var.vpc_name}-subnet"
  network = google_compute_network.tf-vpc.name
  region = var.region
  ip_cidr_range = var.cidr
}

# This will create firewalls for the i27-ecommerce-vpc
resource "google_compute_firewall" "tf-allow-ports" {
  name = var.firewall_name
  network = google_compute_network.tf-vpc.name
  dynamic "allow" {
    for_each = var.ports
    content {
      protocol = "tcp"
      ports = [allow.value]
    }
  }
  source_ranges = ["0.0.0.0/0"]
}


# Generate a SSH key pair
resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

# Save the Private key to a local file 
resource "local_file" "private_key" {
 content = tls_private_key.ssh-key.private_key_pem
 filename =  "${path.module}/id_rsa"         # "/Users/devopswithcloud/Documents/projects-d3/id_rsa" #
}

# Save the Public key to a local file
resource "local_file" "public_key" {
  content = tls_private_key.ssh-key.public_key_openssh
  filename =  "${path.module}/id_rsa.pub"         # "/Users/devopswithcloud/Documents/projects-d3/id_rsa.pub" 
}

# This will create Compute Engine instances which are needed for i27 infrastructure 
resource "google_compute_instance" "tf-vm-instances" {
  for_each = var.instances
  name = each.key
  zone = each.value.zone
  machine_type = each.value.instance_type
  tags = [each.key]
  
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_image.self_link
      size  = 10
      type  = "pd-balanced"
    }
  }
    network_interface {
      access_config {
        network_tier = "PREMIUM"
      }
    network = google_compute_network.tf-vpc.name
    # Below is for subnetwork 
     subnetwork  = google_compute_subnetwork.tf-subnet.name
   # subnetwork = each.key == "sonarqube" ? google_compute_subnetwork.sonarqube-subnet.name : google_compute_subnetwork.tf-subnet.name
  }
 
  
  metadata = {
    ssh-keys = "${var.vm_user}:${tls_private_key.ssh-key.public_key_openssh}"
  }

  metadata_startup_script = "echo hi > /test.txt"

  # Connection 
  connection {
    type = "ssh"
    user = var.vm_user
    host = self.network_interface[0].access_config[0].nat_ip
    private_key = tls_private_key.ssh-key.private_key_pem # Lets use the private key from the TLS resource 
  }

  # Provisioner
  # file, remote-exec, local-exec
  provisioner "file" {
    # If ansible machine, execute ansible.sh
    # if otherthan ansible, execute other.sh
    # condition ? success : Failure
    source =  each.key == "ansible" ? "ansible.sh" : "other.sh"     # Conditional 
    destination = each.key == "ansible" ? "/home/${var.vm_user}/ansible.sh" : "/home/${var.vm_user}/other.sh"
  }

  # In ansible vm, ansibl.sh should execute
#   provisioner "remote-exec" {
#     inline = [ 
#       each.key == "ansible" ? "chmod +x /home/${var.vm_user}/ansible.sh && sh /home/${var.vm_user}/ansible.sh" : "echo 'Skipping the Command!!!!'"
#      ]
#   }

  # Copy the private key to all the machines
#gcloud compute instances describe ansible --zone=us-central1-a
}

output "instance_metadata" {
  # value = google_compute_instance.tf-vm-instances[0].metadata
   value = [for instance in google_compute_instance.tf-vm-instances : {
    name     = instance.name
    metadata = instance.metadata
  }]
}

# Data block to get images 

data "google_compute_image" "ubuntu_image" {
  family = "ubuntu-2004-lts"
  project = "ubuntu-os-cloud"
}