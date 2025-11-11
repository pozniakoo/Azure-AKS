resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = "aks-cluster"
  location            = var.location
  resource_group_name = var.rg-name
  dns_prefix          = "szymon-aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "szymonacrregistry01"
  resource_group_name = var.rg-name
  location            = var.location #sprawdzic czy tak sie robi ze zmiennymi z folderow nadrzednych

  sku                 = "Basic"
  admin_enabled       = false
  tags = {  
  }
}

data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "example" {
}

resource "azurerm_role_assignment" "aks-acr-assignment" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks-cluster.kubelet.identity[0].object_id
  skip_service_principal_aad_check = true
}