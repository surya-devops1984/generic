data "azurerm_resource_group" "rg" {
    name = var.rg_name
}

data "azurerm_virtual_network" "vnet" {
    name = var.vnet_name
    resource_group_name = data.azurerm_resource_group.rg.name
  
}

data "azurerm_subnet" "subnet" {
    name = var.subnet_name
    resource_group_name = data.azurerm_resource_group.rg.name
    virtual_network_name =  data.azurerm_virtual_network.vnet.name
}

data "azurerm_public_ip" "pip" {
    name = var.pip_name
    resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_lb" "lb" {
  name = var.lb_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  name = var.lb_backend_pool_name
  loadbalancer_id = data.azurerm_lb.lb.id
}