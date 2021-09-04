# This file is mainly a placeholder since lab 9 is meant to destroy everything.
# The catchup script will still initialize the workspace and apply this code.
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