

1) How to pass dependencies to helm chart?
2) I want to create logs in s3 bucket, how would you do?
3) Dryrun vs helmtemplate?
4) Regarding Ingress controller
5) Pod is not restarted, what could be the reasons?
6) How control rate limiting?
7) I need to create 10 identical vm's in cloud, what is your approach in terraform?
--counter quetion to above one is, wether we can use counter instead of using foreach.
8)difference between import vs refresh?
9) How would plan for DR?
10) do you know python script?
11) Scernaio:
 you have single node which has 3 cpu and 3gb ram.
 I need 2 pods, one with 1 cpu and 2gb ram and other one with 2 cpu and 1 gb ram.
 How does it works?
12) Image scanning...
13) suddenly pod need more resources?
14) what if user updated configurations on cloud portal instead of doing by terraform?
15) can we create the pod with control panel?
16) kubernetes jobs..

----------------------------
1. how you standardize the kubernets policies like image vulnerbilities.
2. How to check base images are vulnerable before using?
3. Where do you perform ssl termination? ingress manged load balancer or ingress services.
4. do you make any security checks in ingress managed load balancer?
5. how do you pass senstive information to application?
6. What all stuff you control in kubernetes side?
7. How DNS works in Azure, if you two applications with different domains, how routing will happen?
8. if you want to avoid ddos impact, where will you configure them.


---
### Standardize Images and k8s object
Ensuring that base images are not vulnerable and adhering to best practices for Docker and Kubernetes are crucial for maintaining the security and reliability of containerized applications. Here are steps and best practices to achieve this:

### Ensuring Base Images are Not Vulnerable

1. **Use Official and Trusted Images**:
   - Always prefer official images from trusted sources such as Docker Hub or other verified registries.
   - Ensure the images have been regularly updated and maintained.

2. **Scan Images for Vulnerabilities**:
   - Use tools like [Clair](https://github.com/quay/clair), [Trivy](https://github.com/aquasecurity/trivy), [Anchore](https://anchore.com/), and [Snyk](https://snyk.io/) to scan images for known vulnerabilities.
   - Integrate image scanning into your CI/CD pipeline to automatically check for vulnerabilities.

3. **Keep Images Updated**:
   - Regularly update base images to incorporate the latest security patches.
   - Avoid using `latest` tag as it can lead to inconsistent builds; specify the exact version.

4. **Minimize Image Size**:
   - Use minimal base images like `alpine` or `distroless` to reduce the attack surface.
   - Remove unnecessary packages and files to minimize the image size and potential vulnerabilities.

5. **Use Multi-stage Builds**:
   - Use multi-stage builds to keep the final image lean by only including the necessary artifacts.
   - This approach separates the build environment from the runtime environment, reducing the potential attack surface.

### Best Practices to Standardize Docker and Kubernetes

#### Docker Best Practices

1. **Write Secure Dockerfiles**:
   - Use non-root users where possible by adding a user in the Dockerfile and running the application as that user.
   - Specify a health check in the Dockerfile to ensure the container is running as expected.
   - Use `.dockerignore` to exclude unnecessary files from the build context.

   **Example Dockerfile**:
   ```Dockerfile
   FROM alpine:3.12
   RUN addgroup -S mygroup && adduser -S myuser -G mygroup
   USER myuser
   WORKDIR /app
   COPY --chown=myuser:mygroup . /app
   CMD ["./myapp"]
   ```

2. **Limit Resource Usage**:
   - Set resource limits to prevent containers from consuming excessive CPU and memory.

   **Example**:
   ```Dockerfile
   FROM node:14-alpine
   COPY . /app
   WORKDIR /app
   RUN npm install
   USER node
   CMD ["node", "index.js"]
   ```

3. **Use Read-Only Filesystems**:
   - Run containers with read-only file systems where possible to minimize the risk of tampering.

   **Example**:
   ```yaml
   version: '3.8'
   services:
     app:
       image: myapp:latest
       volumes:
         - /app/data
       read_only: true
   ```

#### Kubernetes Best Practices

1. **Pod Security Policies**:
   - Use Pod Security Policies or the newer Pod Security Standards to enforce security configurations for your pods.

   **Example**:
   ```yaml
   apiVersion: policy/v1beta1
   kind: PodSecurityPolicy
   metadata:
     name: restricted
   spec:
     privileged: false
     allowPrivilegeEscalation: false
     runAsUser:
       rule: 'MustRunAsNonRoot'
     seLinux:
       rule: 'RunAsAny'
     supplementalGroups:
       rule: 'MustRunAs'
       ranges:
         - min: 1
           max: 65535
     fsGroup:
       rule: 'MustRunAs'
       ranges:
         - min: 1
           max: 65535
     readOnlyRootFilesystem: true
   ```

2. **Network Policies**:
   - Define Network Policies to control the traffic flow between pods and services.

   **Example**:
   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: allow-app
   spec:
     podSelector:
       matchLabels:
         app: myapp
     policyTypes:
       - Ingress
     ingress:
       - from:
           - podSelector:
               matchLabels:
                 role: frontend
   ```

3. **Resource Limits and Requests**:
   - Set resource requests and limits to ensure that applications run reliably and do not consume more resources than expected.

   **Example**:
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: mypod
   spec:
     containers:
     - name: mycontainer
       image: myimage
       resources:
         requests:
           memory: "64Mi"
           cpu: "250m"
         limits:
           memory: "128Mi"
           cpu: "500m"
   ```

4. **Use Secrets and ConfigMaps**:
   - Store sensitive information such as passwords and API keys in Kubernetes Secrets, and configuration data in ConfigMaps.

   **Example**:
   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: mysecret
   type: Opaque
   data:
     password: dGVzdHBhc3M=
   ```

5. **Image Pull Policies**:
   - Use appropriate image pull policies (`IfNotPresent`, `Always`, `Never`) to control how Kubernetes pulls images.

   **Example**:
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: mypod
   spec:
     containers:
     - name: mycontainer
       image: myimage
       imagePullPolicy: IfNotPresent
   ```

### Summary

1. **For Docker**:
   - Use official, minimal, and trusted base images.
   - Regularly scan images for vulnerabilities.
   - Keep images up to date.
   - Use multi-stage builds and non-root users.

2. **For Kubernetes**:
   - Implement Pod Security Policies and Network Policies.
   - Use resource limits and requests.
   - Store sensitive data in Secrets.
   - Set appropriate image pull policies.

By following these best practices, you can enhance the security and standardization of your Docker and Kubernetes environments, reducing the risk of vulnerabilities and ensuring more reliable deployments.

## Terraform backends

## Terraform Workspace:
In Terraform, a **workspace** is an isolated environment within a single Terraform configuration, allowing you to manage multiple environments (like `development`, `staging`, `production`, etc.) with the same configuration code. Workspaces provide a way to keep separate state files for each environment while using the same codebase.

### Key Concepts of Terraform Workspaces

1. **Default Workspace**:
   - Every Terraform configuration starts with a default workspace named `default`.
   - The `default` workspace is used if you don't create or switch to another workspace.

2. **Named Workspaces**:
   - You can create additional workspaces with custom names.
   - Each workspace has its own state file, isolating the resources managed by Terraform.

3. **Workspace Use Cases**:
   - **Environment Isolation**: Separate environments (e.g., dev, staging, prod) can be managed in different workspaces.
   - **Testing**: Use workspaces to create a sandbox for testing changes before applying them to production.
   - **Feature Branches**: Developers can create temporary workspaces for feature branches.

4. **Managing Workspaces**:
   - **Create a Workspace**: Use `terraform workspace new <workspace-name>` to create a new workspace.
   - **List Workspaces**: Use `terraform workspace list` to view all workspaces.
   - **Switch Workspaces**: Use `terraform workspace select <workspace-name>` to switch to another workspace.
   - **Delete a Workspace**: Use `terraform workspace delete <workspace-name>` to remove a workspace.

5. **Referencing Workspaces**:
   - You can reference the current workspace in your Terraform code using the `${terraform.workspace}` expression.

### Example Workflow

1. **Creating a New Workspace**:
   ```sh
   terraform workspace new dev
   ```

2. **Switching Between Workspaces**:
   ```sh
   terraform workspace select prod
   ```

3. **Using Workspaces in Configuration**:
   ```hcl
   resource "aws_s3_bucket" "example" {
     bucket = "my-bucket-${terraform.workspace}"
     acl    = "private"
   }
   ```
   In the above example, the bucket name will be suffixed with the current workspace name, creating separate buckets for `dev`, `staging`, and `prod` workspaces.

### Best Practices

- **State Management**: Workspaces are a convenient way to manage different states, but for complex setups, consider using separate state files or Terraform Cloud/Enterprise for better isolation.
- **Avoid Overcomplication**: If your infrastructure varies significantly between environments, it might be better to maintain separate configurations instead of overloading a single configuration with conditionals based on workspaces.

Terraform workspaces are powerful but should be used thoughtfully to manage different environments effectively while keeping configurations maintainable.

## tfenv
`tfenv` is a Terraform version manager that simplifies the process of installing and managing multiple versions of Terraform. It allows users to switch between different versions of Terraform seamlessly and ensures that the correct version is used for each project. This is particularly useful when working on multiple projects that may require different versions of Terraform or when updating to newer versions.

### Key Features of `tfenv`

1. **Installation of Multiple Versions**: Easily install and manage multiple versions of Terraform.
2. **Version Switching**: Switch between installed versions of Terraform as needed.
3. **Version Pinning**: Specify a specific Terraform version for a project, ensuring consistency.
4. **Automatic Version Detection**: Detects the required version of Terraform based on a configuration file in your project.

### Installation of `tfenv`

To install `tfenv`, follow these steps:

1. **Install Dependencies**: Ensure you have `git` and `curl` installed.

2. **Clone the `tfenv` Repository**:
   ```sh
   git clone https://github.com/tfutils/tfenv.git ~/.tfenv
   ```

3. **Add `tfenv` to Your PATH**:
   ```sh
   echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
   source ~/.bash_profile
   ```

### Using `tfenv`

#### Installing a Specific Version of Terraform

To install a specific version of Terraform, use the `tfenv install` command followed by the version number:
```sh
tfenv install 1.0.0
```

#### Setting a Version as Default

To set a specific version of Terraform as the default, use the `tfenv use` command:
```sh
tfenv use 1.0.0
```

#### Specifying a Version for a Project

To specify a Terraform version for a particular project, create a `.terraform-version` file in the project's root directory and add the desired version number to this file:
```sh
echo "1.0.0" > .terraform-version
```
When you navigate to the project directory, `tfenv` will automatically use the version specified in the `.terraform-version` file.

#### Listing Installed Versions

To list the versions of Terraform that are currently installed, use:
```sh
tfenv list
```

#### Uninstalling a Version

To uninstall a specific version of Terraform, use:
```sh
tfenv uninstall 1.0.0
```

### Example Workflow with `tfenv`

1. **Install `tfenv`**:
   ```sh
   git clone https://github.com/tfutils/tfenv.git ~/.tfenv
   echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
   source ~/.bash_profile
   ```

2. **Install the Required Terraform Version**:
   ```sh
   tfenv install 1.0.0
   ```

3. **Set the Installed Version as Default**:
   ```sh
   tfenv use 1.0.0
   ```

4. **Specify a Version for a Project**:
   ```sh
   echo "1.0.0" > .terraform-version
   ```

By using `tfenv`, you can easily manage multiple versions of Terraform, ensuring that you are using the correct version for each of your projects. This helps in maintaining consistency and avoiding issues related to version incompatibility.

## Provisioers
* Execute package or configurations

* `**file**`
* `**remote-exec**`
* `**local-exec**`

The **file provisioner** copies files or directories from the machine running Terraform to the newly created resource. The file provisioner supports both ssh and winrm type connections

The **remote-exec** provisioner invokes a script on a remote resource after it is created

The **local-exec** provisioner invokes a local executable after a resource is created

* `**self**`

```terraform
connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file("id_rsa")
}

provisioner "file" {
    source = "entry.sh"
    destination = "/home/ec2-user/entry-script.sh"
}

provisioner "remote-exec" {
    inline =[
        "mkdir batch3",
        "sh entry-script.sh"
    ]
    #script = file("/home/ec2-user/entry-script.sh")
}
provisioner "local-exec" {
    command = "echo ${self.public_ip} > localoutputs.txt"
}
```
* to work on terraform, for each resource we need to know pre-requisites

Terraform **provisioners** are used to execute scripts or commands on a local or remote machine as part of the resource creation or destruction process. Provisioners allow you to customize your infrastructure and perform tasks that are not directly supported by Terraform's built-in resource types.

### When to Use Provisioners

- **Bootstrapping**: To install software or perform configurations on a VM after it has been created.
- **Integration**: To execute commands that integrate with external systems.
- **Fallback**: As a last resort when Terraform cannot natively manage a particular aspect of your infrastructure.

### Types of Provisioners

1. **File Provisioner**:
   - Copies files or directories from the machine running Terraform to the target resource.
   
   **Example**:
   ```hcl
   resource "aws_instance" "example" {
     ami           = "ami-123456"
     instance_type = "t2.micro"

     provisioner "file" {
       source      = "local-file.txt"
       destination = "/tmp/remote-file.txt"
     }

     connection {
       type        = "ssh"
       user        = "ec2-user"
       private_key = file("~/.ssh/id_rsa")
       host        = self.public_ip
     }
   }
   ```

2. **Remote-Exec Provisioner**:
   - Runs commands on a remote machine after the resource is created.
   
   **Example**:
   ```hcl
   resource "aws_instance" "example" {
     ami           = "ami-123456"
     instance_type = "t2.micro"

     provisioner "remote-exec" {
       inline = [
         "sudo apt-get update",
         "sudo apt-get install -y nginx"
       ]
     }

     connection {
       type        = "ssh"
       user        = "ec2-user"
       private_key = file("~/.ssh/id_rsa")
       host        = self.public_ip
     }
   }
   ```

3. **Local-Exec Provisioner**:
   - Runs commands on the machine where Terraform is executed, not on the target resource.
   
   **Example**:
   ```hcl
   resource "aws_instance" "example" {
     ami           = "ami-123456"
     instance_type = "t2.micro"

     provisioner "local-exec" {
       command = "echo ${self.public_ip} >> ip_list.txt"
     }
   }
   ```

### Provisioner Configuration

#### **Connection Block**
Provisioners that require communication with remote machines (like `file` and `remote-exec`) need a `connection` block to define how to connect.

**SSH Connection Example**:
```hcl
connection {
  type        = "ssh"
  user        = "ubuntu"
  private_key = file("~/.ssh/id_rsa")
  host        = self.public_ip
}
```

**WinRM Connection Example**:
```hcl
connection {
  type     = "winrm"
  user     = "Administrator"
  password = "Password123!"
  host     = self.public_ip
}
```

### Provisioner Lifecycle

1. **Creation-Time Provisioners**:
   - Run after the resource is created. If the provisioner fails, Terraform marks the resource as "tainted," and the next run will destroy and recreate the resource.

2. **Destruction-Time Provisioners**:
   - Run before the resource is destroyed. If the provisioner fails, Terraform will continue destroying the resource.

**Example**:
```hcl
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    when    = "destroy"
    command = "echo 'Destroying instance ${self.id}'"
  }
}
```

### Handling Provisioner Failures

- **Ignore Failures**: You can set `on_failure = continue` to allow Terraform to continue even if the provisioner fails.

  **Example**:
  ```hcl
  provisioner "remote-exec" {
    inline = ["command-that-might-fail"]
    on_failure = "continue"
  }
  ```

### Best Practices

- **Use Provisioners Sparingly**: Provisioners should be a last resort. If possible, use Terraform's native resource types or configuration management tools like Ansible, Chef, or Puppet.
- **Idempotency**: Ensure the commands or scripts run by provisioners are idempotent (can be run multiple times without changing the result).
- **Plan for Failures**: Be aware that if a provisioner fails, Terraform may not be able to recover gracefully, especially during resource creation.

### Example: Using Multiple Provisioners

```hcl
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"

  # Copy a file to the instance
  provisioner "file" {
    source      = "local-script.sh"
    destination = "/tmp/remote-script.sh"
  }

  # Run the script on the instance
  provisioner "remote-exec" {
    script = "/tmp/remote-script.sh"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
}
```

In this example, a file is copied to the instance, and then a script is executed on the remote machine using the `file` and `remote-exec` provisioners, respectively.