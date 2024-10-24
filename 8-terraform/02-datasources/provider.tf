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