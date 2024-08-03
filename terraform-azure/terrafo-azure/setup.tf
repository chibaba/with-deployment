# initialize terraform and azure providers


terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
        source = "hashicorp/azurerm" # https://registry.terraform.io/providers/hashicorp/azurerm/latest
        version = "~>3.0"
    }

    azurecaf = {
        source = "aztfmod/azurecaf" # https://registry.terraform.io/providers/aztfmod/azurecaf/latest
    }
  }
}