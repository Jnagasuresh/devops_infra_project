resource "azurerm_resource_group" "linuxrg" {
  name     = var.rg_name
  location = var.rg_location
}


resource "azurerm_virtual_network" "linuxvnet" {
  name                = var.vnet_name
  address_space       = var.vnet_addr_space
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "count_subnet" {
  count                = length(var.subnet_name)
  name                 = var.subnet_name[count.index]
  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_name
  address_prefixes     = ["10.10.${count.index}.0/16"]
}