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


variable "subnet1_name" {
  type = string
}

variable "subnet1_addr_prefix" {
  type = list(string)
}


variable "nic_name" {
  type = string
}

variable "linuxVM_name" {
  type = string
}

variable "asp_name" {
  type = string
}

variable "webapp_name" {
  type = string
}