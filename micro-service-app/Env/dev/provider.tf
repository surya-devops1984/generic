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

}
