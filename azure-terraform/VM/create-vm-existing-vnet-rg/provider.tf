# Define Terraform provider
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.22.0"
    }
  }
#  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}
