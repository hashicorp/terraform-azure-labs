# The terraform block is used to configure provider versions
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# The provider block allows you to customize individual provider settings.
provider "azurerm" {
  features {}
}