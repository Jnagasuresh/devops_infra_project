variable "rg_name" {
  type = string
  default = "linuxvm"
}

variable "rg_location" {
  type = string
  default = "EastUS"
}

variable "vnet_name" {
  type = string
  default = "linuxvet"
}

variable "address_space" {
  type = list(string)
}


variable "subnet_name" {
  type = string
}



variable "pip" {
  type = string
}

