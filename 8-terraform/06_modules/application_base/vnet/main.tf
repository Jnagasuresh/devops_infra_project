resource "azurerm_resource_group" "concept_rg1" {
  name = var.rg_name
  location =  var.rg_location
}

resource "azurerm_virtual_network" "concept_vnet1" {
    name = var.vnet_name
    resource_group_name = azurerm_resource_group.concept_rg1.name
    location = azurerm_resource_group.concept_rg1.location
    address_space = var.vnet_address_space
  
}
resource "azurerm_subnet" "concept_subnet1" {
  name = var.subnet1_name
  virtual_network_name = azurerm_virtual_network.concept_vnet1.name
  resource_group_name = azurerm_resource_group.concept_rg1.name
  address_prefixes = var.subnet_addr_prefix
}