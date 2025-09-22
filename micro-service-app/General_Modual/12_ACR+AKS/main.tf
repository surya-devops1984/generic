resource "azurerm_container_registry" "acr" {
  name = var.acr_name                                         #ACR ka naam
  resource_group_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  sku = var.acr_sku                                            #Premium → iska matlab high-performance, geo-replication aur advanced features wala registry.
  admin_enabled = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name = var.aks_name
  location = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix =  var.aks_dns_prefix                                   #cluster ke API server endpoint ka prefix banega.

  default_node_pool {
    name = var.aks_node_pool_name
    node_count = var.aks_node_count
    vm_size = var.aks_node_vmsize
  }

   identity {
    type = "SystemAssigned"     #AKS cluster ke liye ek System Assigned Managed Identity banega.
   #Ye identity Azure resources (jaise ACR) access karne ke liye use hogi
   }

}

resource "azurerm_role_assignment" "aks_acr_assignment" {   #AKS ko ACR se images pull karne ka right deta hai.
  principal_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id    #AKS ka kubelet identity (jo pods run karte hain).
  role_definition_name = "AcrPull"                       #ye ek built-in Azure role hai jo ACR se images pull karne allow karta hai.
  scope =  azurerm_container_registry.acr.id                                              #role assignment ka scope = tere ACR ki id
  skip_service_principal_aad_check = true                #SPN ka AAD validation skip karta hai (Terraform best practice).
  #Matlab: AKS apne pods ke liye directly ACR se images pull kar paayega bina manually credentials diye.

}

