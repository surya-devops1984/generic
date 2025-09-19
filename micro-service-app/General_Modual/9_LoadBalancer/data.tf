data "azurerm_resource_group" "rg" {
    name = var.rg_name
  
}

data "azurerm_public_ip" "pip" {
  name = var.pip_name
  resource_group_name = data.azurerm_resource_group.rg.name
}