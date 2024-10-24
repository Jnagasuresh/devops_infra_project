resource "azurerm_resource_group" "tfrg" {
  name = "myterraformrg"
  location = "East US"
}

# terraform import
# terraform import azurerm_resource_group.tfrg /subscriptions/8734d22c-6905-43a5-a1cf-9e033ef6352c/resourceGroups/myterraformrg

# terraform import azurerm_virtual_network.tfvnet  /subscriptions/8734d22c-6905-43a5-a1cf-9e033ef6352c/resourceGroups/myterraformrg/providers/Microsoft.Network/virtualNetworks/tfvnet19
resource "azurerm_virtual_network" "tfvnet" {
  name = "TFVNET19"
  location = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
  address_space = ["10.0.0.0/16"]
}