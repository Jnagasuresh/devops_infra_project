variable "rg_name" {
  type = string
  description = "Resource group name"
  default = "ConceptLinuxRG"
}

variable "rg_location" {
  type = string
  description = "Location"
}

variable "vnet_name" {
  type = string
}

variable "vnet_addr_space" {
  type = list(string)
}

variable "subnet_name" {
  type = list(string)
}