terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "=4.4.0"
            }
        }

    backend "azurerm" {
      resource_group_name = "staterg"
      storage_account_name = "statefilestgaccount"
      container_name = "tfstate"
      key ="dev/dev.tfstate"
      //$env:ARM_ACCESS_KEY = "your_storage_account_access_key" -- this defined in environment variable
      #access_key = var.backend_access_key
    }
}

# Configure the Microsoft Azure Providerprovider
provider "azurerm" { 
    features {}
     subscription_id = "8734d22c-6905-43a5-a1cf-9e033ef6352c"
    }

module "dev" {
    source = "../../application_base/vnet"  
    rg_name = "devrg"
    rg_location ="EastUS"
    vnet_name ="devtfvent"
    vnet_address_space =  [ "10.0.0.0/16" ]
    subnet1_name = "devtfsubnet1"
    subnet_addr_prefix =  ["10.0.0.0/24"]
    nic_name = "devnic1"
}

module "virtualmachine" {
    source = "../../virtualmachine"

    rg_name = "devrg"
    rg_location = "EastUS"
    subnetid = ""   
    env = "dev" 
    
}