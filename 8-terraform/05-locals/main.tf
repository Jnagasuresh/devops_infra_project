resource "azurerm_resource_group" "linuxrg" {
  name     = var.rg_name
  location = var.rg_location
}
locals {
rg_name = azurerm_resource_group.linuxrg.name
rg_location = azurerm_resource_group.linuxrg.location
}
/*
resource "azurerm_virtual_network" "linuxvnet" {
  name                = var.vnet_name
  address_space       = var.vnet_addr_space
  location            = local.rg_location
  resource_group_name = local.rg_name
}
*/
/*
resource "azurerm_subnet" "linuxsubnet1" {
  name                 = var.subnet1_name
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.linuxvnet.name
  address_prefixes     = var.vnet_addr_space
}
*/
/*
resource "azurerm_network_interface" "linux_nic" {
  name                = var.nic_name
  location            = local.rg_location
  resource_group_name = local.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.linuxsubnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}
*/
/*
resource "azurerm_linux_virtual_machine" "linexvm01" {
  name                = var.linuxVM_name
  resource_group_name = local.rg_name
  location            = local.rg_location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  disable_password_authentication = false
  admin_password = "Secure$98989"
  network_interface_ids = [
    azurerm_network_interface.linux_nic.id,
  ]

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
*/
# App Service Plan
/*
resource "azurerm_service_plan" "linux_asp_plan" {
  name                = var.asp_name
  resource_group_name = local.rg_name
  location            = local.rg_location
  os_type             = "Linux"
  sku_name            = "B1"
}
*/
/*
resource "azurerm_linux_web_app" "linuxdotnetplan" {
  name                = var.webapp_name
  resource_group_name = local.rg_name
  location            = local.rg_location
  service_plan_id     = azurerm_service_plan.linux_asp_plan.id

  site_config {}

  tags = {
    "purpose" = "Terraform practice"
  }
  
}
*/

resource "azurerm_automation_account" "automation_act1" {
  name                = "medsol-automation-aa"
  location            = azurerm_resource_group.linuxrg.location
  resource_group_name = azurerm_resource_group.linuxrg.name
  sku_name            = "Basic"
  
   identity {
     type = "SystemAssigned"
   }
  tags = {
    environment = "development"
  }
}

# Get the subscription ID to use in role assignment scope
data "azurerm_client_config" "automation_config" {}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}
data "azurerm_subscription" "primary" {
}
# Assign the Contributor role to the system-assigned managed identity of the Automation Account
resource "azurerm_role_assignment" "automaiton_role_assignment" {
  principal_id         = azurerm_automation_account.automation_act1.identity[0].principal_id
  role_definition_name = "Contributor"
  #scope               = azurerm_resource_group.linuxrg.id
  scope                = data.azurerm_subscription.primary.id
}

output "azurerm_subscription" {
  value = "My  Azure subscription id is ${data.azurerm_subscription.primary.id}"
}
