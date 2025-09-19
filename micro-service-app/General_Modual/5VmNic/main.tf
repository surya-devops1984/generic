resource "azurerm_network_interface" "nic-agra" {
    name = var.nic_name
    location = data.azurerm_resource_group.rg.location
    resource_group_name = data.azurerm_resource_group.rg.name
    ip_configuration {
      name = "internal"
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = data.azurerm_public_ip.pip.id
      subnet_id = data.azurerm_subnet.subnet.id
    }
  }

resource "azurerm_linux_virtual_machine" "linux-vm" {
  depends_on = [ azurerm_network_interface.nic-agra ]
  name = var.vm_name
  location = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  size = "Standard_F2"
  admin_username      = var.vm_admin_username
  admin_password      = var.vm_admin_userpassword
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic-agra.id, 
    ]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

 source_image_reference {
   publisher = "canonical"                  #Publisher ID
   offer = "ubuntu-24_04-lts"   #Product ID
   sku = "ubuntu-pro-gen1"                    #Plan ID
   version = "latest"
 }
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_lb_backendpool" {
  ip_configuration_name = "Internal"
  network_interface_id = azurerm_network_interface.nic-agra.id
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.lb_backend_pool.id
  
}