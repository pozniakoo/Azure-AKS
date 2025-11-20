resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = var.node_size
    vnet_subnet_id = var.aks_subnet_id
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
    service_cidr = var.aks_service_cidr
    dns_service_ip = var.kube_dns_ip
  }
  private_cluster_enabled = true
  private_dns_zone_id = "System"

  identity {
    type = "SystemAssigned"
  }

  tags = {
  }
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_registry_name
  resource_group_name = var.rg_name
  location            = var.location 

  sku                 = "Premium" #Premium SKU is required for private connection
  public_network_access_enabled = false
  admin_enabled       = false
  tags = {  
  }
}


resource "azurerm_role_assignment" "aks_acr_assignment" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_private_endpoint" "acr_pe" {
  name                = "${var.acr_registry_name}-pe"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "${var.acr_registry_name}-connection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names = ["registry"]
  }
}

resource "azurerm_private_dns_a_record" "acr_record" {
  name                = var.acr_registry_name
  zone_name           = var.acr_dns_zone_name
  resource_group_name = var.network_rg_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.acr_pe.private_service_connection[0].private_ip_address]
}
