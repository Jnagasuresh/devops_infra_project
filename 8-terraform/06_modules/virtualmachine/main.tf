
# resource "azurerm_network_interface" "main" {
#   name                = "${var.env}-nic"
#   location            = var.rg_location
#   resource_group_name = var.rg_name

#   ip_configuration {
#     name                          = "testconfiguration1"
#     subnet_id                     = var.subnetid
#     private_ip_address_allocation = "Dynamic"
#   }
# }