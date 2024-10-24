variable "rg_name" {
  type = string
  description = "Resource group Name"
}

variable "rg_location" {
  type = string
  description = "location"
  default = "east us"
}
variable "vnet_name" {
    type = string
    description = "vnet name"  
}

variable "vnet_address_space" {
  type = list(string)
}

variable "subnet1_name" {
type = string
}

variable "subnet_addr_prefix" {
type = list(string)
}