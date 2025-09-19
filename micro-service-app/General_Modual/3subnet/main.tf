resource "azurerm_subnet" "subnet" {
  name = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name = data.azurerm_resource_group.rg.name
  address_prefixes = var.subnet_address_prefixes
}