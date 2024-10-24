variable "rg_name" {
  type = string
  description = "Resource group Name"
}


variable "rg_location" {
  type = string
  description = "location"
  default = "east us"
}

variable "env" {
    type = string
    description = "Environment"
}

variable "subnetid" {
    type = string
    description = "SubnetID"
}