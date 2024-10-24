terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "=4.4.0"
            }
        }
        }

# Configure the Microsoft Azure Providerprovider
provider "azurerm" { 
    features {}
     subscription_id = "8734d22c-6905-43a5-a1cf-9e033ef6352c"
    }
    
resource "azurerm_resource_group" "tfrg" {
    name = "TFRG"
    location = "East US"
    }

    resource "azurerm_network_ddos_protection_plan" "tfddos01" {
    name                = "tfddosp1"
    location            = azurerm_resource_group.tfrg.location
    resource_group_name = azurerm_resource_group.tfrg.name
    }

    resource "azurerm_virtual_network" "tfvnet" { 
        name = "TFVNET01"
        address_space = ["10.1.0.0/16"] #65536 Ip Addresses
        location = azurerm_resource_group.tfrg.location
        resource_group_name = azurerm_resource_group.tfrg.name

        ddos_protection_plan {
          id = azurerm_network_ddos_protection_plan.tfddos01.id
          enable = true
        }
        
        encryption {
          enforcement = "AllowUnencrypted"
        }

        }
    
    resource "azurerm_subnet" "tfsubnet1" {
        name = "Subnet01"
        resource_group_name = azurerm_resource_group.tfrg.name
        virtual_network_name = azurerm_virtual_network.tfvnet.name
        address_prefixes = ["10.1.0.0/24"] #254 Ip Addresses
        }

    resource "azurerm_subnet""tfsubnet2"{
        name = "Subnet02"
        resource_group_name = azurerm_resource_group.tfrg.name
        virtual_network_name = azurerm_virtual_network.tfvnet.name
        address_prefixes = ["10.1.1.0/24"] #254 Ip Addresses
        }

        resource "azurerm_network_interface" "tfnic01" {
        name                = "linuxnic01"
        location            = azurerm_resource_group.tfrg.location
        resource_group_name = azurerm_resource_group.tfrg.name

        ip_configuration {
            name                          = "internal"
            subnet_id                     = azurerm_subnet.tfsubnet1.id
            private_ip_address_allocation = "Dynamic"
        }
        }
