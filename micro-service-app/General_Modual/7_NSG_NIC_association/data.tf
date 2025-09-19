data "azurerm_network_interface" "nic" {
  name = var.nic_name
  resource_group_name =data.azurerm_resource_group.rg.name
}

data "azurerm_resource_group" "rg" {
    name = var.rg_name
  
}

data "azurerm_network_security_group" "nsg" {
  name = var.nsg_name
  resource_group_name = data.azurerm_resource_group.rg.name
}