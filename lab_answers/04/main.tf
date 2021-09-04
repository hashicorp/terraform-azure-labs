terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tflab_rg" {
  name     = "tflab-resource-group"
  location = "Central US"
}

resource "azurerm_virtual_network" "tflab_vn" {
  name                = "tflab-virtual-network"
  location            = azurerm_resource_group.tflab_rg.location
  resource_group_name = azurerm_resource_group.tflab_rg.name
  address_space       = ["10.0.0.0/16"]
}