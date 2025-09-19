resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Standard_F2"
  instances           = var.starting_instance_count
  admin_username      = var.vmss_admin_username
  admin_password      = var.vmss_admin_password


  source_image_reference {
    publisher = var.os_publisher
    offer     = var.os_offer
    sku       = var.os_sku
    version   = var.os_version
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = var.nic_name
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = data.azurerm_subnet.subnet_id.id
      load_balancer_backend_address_pool_ids = [data.azurerm_lb_backend_address_pool.lb_backend_pool.id]
  }
  
}
}
resource "azurerm_monitor_autoscale_setting" "vmss_autoscale" {          # Autoscale setting resource for the VMSS
  name                = "vmss-autoscale"                                 # Resource का नाम
  resource_group_name =  data.azurerm_resource_group.rg.name            # जिस Resource Group में बनेगा
  location            =  data.azurerm_resource_group.rg.location                                               # Resource की location
  target_resource_id  =  azurerm_linux_virtual_machine_scale_set.vmss.id  # जिस VMSS को scale करना है - उसका ID

  profile {                          # एक या ज़्यादा profiles; यहाँ defaultProfile use कर रहे हैं
    name = "defaultProfile"           # Profile का नाम

    capacity {             # Profile के अंदर capacity limits
      minimum = var.vm_count_min          # Minimum VM count
      maximum = var.vm_count_max       # Maximum VM count
      default = var.vm_count_default          # Default / starting VM count
    }

     # ---- Scale Out rule (जब metric threshold cross हो तो VM बढ़ाने के लिए) ----
    rule {                  # एक scale rule block
      metric_trigger {      # कब trigger होगा इसे define करता है
        metric_name        = "Percentage CPU"                                        # Monitor करने वाली metric
        metric_resource_id =  azurerm_linux_virtual_machine_scale_set.vmss.id      # Metric किस resource पर है (VMSS id)
        operator           = "GreaterThan"                                          # Operator (GreaterThan / LessThan)
        statistic          = "Average"                                              # Statistic type (Average, Minimum, Maximum)
        threshold          = var.vm_increase_threshold                                                    # Threshold value (यहाँ CPU > 70%)
        time_grain         = "PT1M"                                                 # Metric granularity (1 minute)
        time_window        = "PT5M"                                                 # Lookback window (पिछले 5 मिनट का average)
        time_aggregation   = "Average"                                              # Time aggregation method
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"           # Metric namespace (VMSS के लिए)
      }

      scale_action { # Trigger होने पर कौनसा action होगा
        direction = "Increase"    # Increase => scale out
        type      = "ChangeCount" # ChangeCount => instance count change
        value     = var.vm_increase_count          # हर बार कितने VM add होंगे (यहाँ 1)
        cooldown  = "PT5M"        # Action के बाद cooldown (5 मिनट) - अगली action से पहले wait
      }
    }

    # ---- Scale In rule (जब metric low हो तो VM घटाने के लिए) ----
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"                                        # वही metric
        metric_resource_id =  azurerm_linux_virtual_machine_scale_set.vmss.id       # VMSS id
        operator           = "LessThan"                                             # LessThan => scale in trigger
        statistic          = "Average"
        threshold          = var.vm_decrease_threshold                                                    # Threshold value (यहाँ CPU < 30%)
        time_grain         = "PT1M"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Decrease"  # Decrease => scale in
        type      = "ChangeCount"
        value     = var.vm_decrease_count       # हर बार कितने VM remove होंगे (यहाँ 1)
        cooldown  = "PT5M"      # Scale in के बाद cooldown
      }
    }
  }

  notification { # Optional: notifications जब scaling होता है
    email {
      send_to_subscription_administrator    = true               # Subscription admin को mail भेजे
      send_to_subscription_co_administrator = true               # Co-admin को भी भेजे
      custom_emails                         = ["admin@example.com"] # Extra custom emails
    }
  }
} # resource end