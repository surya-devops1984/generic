data "azurerm_resource_group" "rg" {
  name = var.rg_name  #azurerm_resource_group.rg.name
}

data "azurerm_virtual_network" "vnet" {
  name = var.Vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}