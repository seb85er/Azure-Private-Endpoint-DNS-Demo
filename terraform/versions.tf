terraform {
  required_version = ">= 1.1.9"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.6.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.77.0"
    }
  }
}