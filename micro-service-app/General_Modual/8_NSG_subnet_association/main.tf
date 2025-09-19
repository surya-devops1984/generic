resource "azurerm_subnet_network_security_group_association" "nsg_subnet_association" {
  subnet_id                 = data.azurerm_subnet.namesubnet.id
  network_security_group_id = data.azurerm_network_security_group.nsg.id
}