resource "azurerm_lb" "load_balancer" {
  name                = "LoadBalancer"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = data.azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "BackEndAddressPool"
}



resource "azurerm_lb_probe" "health_prob" {  #Health probe ka kaam hai check karna ki backend VM healthy hai ya nahi.
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "health-probe"
  port            = 22
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = var.lb_frontend_port
  backend_port                   = var.lb_backend_port
  frontend_ip_configuration_name = "PublicIPAddress"
}

# resource "azurerm_lb_nat_pool" "example" {        # used for scale set scenario, jisme har instance ko alag port diya jata hai automatically.
#   resource_group_name            = azurerm_resource_group.example.name
#   loadbalancer_id                = azurerm_lb.example.id
#   name                           = "SampleApplicationPool"
#   protocol                       = "Tcp"
#   frontend_port_start            = 80
#   frontend_port_end              = 81
#   backend_port                   = 8080
#   frontend_ip_configuration_name = "PublicIPAddress"
# }

# resource "azurerm_lb_nat_rule" "example1" {     #ek-ek specific port forwarding (single VM ke liye best).   
#   resource_group_name            = azurerm_resource_group.example.name
#   loadbalancer_id                = azurerm_lb.example.id
#   name                           = "RDPAccess"
#   protocol                       = "Tcp"
#   frontend_port_start            = 3000
#   frontend_port_end              = 3389
#   backend_port                   = 3389
#   backend_address_pool_id        = azurerm_lb_backend_address_pool.example.id
#   frontend_ip_configuration_name = "PublicIPAddress"
# }

# resource "azurerm_lb_outbound_rule" "example" {
#   name                    = "OutboundRule"
#   loadbalancer_id         = azurerm_lb.example.id
#   protocol                = "Tcp"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.example.id

#   frontend_ip_configuration {
#     name = "PublicIPAddress"
#   }
# }

# resource "azurerm_lb_backend_address_pool_address" "example-2" {
#   name                                = "address2"
#   backend_address_pool_id             = data.azurerm_lb_backend_address_pool.backend-pool-cr.id
#   backend_address_ip_configuration_id = azurerm_lb.backend-lb-R2.frontend_ip_configuration[0].id
# }
