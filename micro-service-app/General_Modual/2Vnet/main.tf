
resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  location = data.azurerm_resource_group.rg-data.location
  resource_group_name = data.azurerm_resource_group.rg-data.name
  address_space = var.vnet_address
}