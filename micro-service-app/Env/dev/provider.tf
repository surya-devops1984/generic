terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "4.44.0"
    }
  }
#   backend "azurerm" {
#     resource_group_name = "value"
#     storage_account_name = "value"
#     container_name = "value"
#     key = "value"
#   }
}

provider "azurerm" {
  features {}
  subscription_id = "81cc1915-8d88-419e-8fa3-0178811761bd"
}