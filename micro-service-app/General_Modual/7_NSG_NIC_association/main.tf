resource "azurerm_network_interface_security_group_association" "ngs_nic_association" {
  network_interface_id      = data.azurerm_network_interface.nic.id
  network_security_group_id = data.azurerm_network_security_group.nsg.id
}