resource "azurerm_resource_group" "AKS_Cluster_RG" {
  name     = "aks-cluster-rg"
  location = var.location

  tags = {
    usage    = "AKS Cluster resource group"
    location = var.location
  }
}

module "k8s" {
  source = "./modules/k8s"

  location           = var.location
  aks_rg_name        = azurerm_resource_group.AKS_Cluster_RG.name
  acr_registry_name  = var.acr_registry_name
  vnet_id            = module.network.vnet_id
  aks_subnet_id      = module.network.aks_subnet_id
  pe_subnet_id       = module.network.pe_subnet_id
  bastion_subnet_id  = module.network.bastion_subnet_id
  jumphost_subnet_id = module.network.jumphost_subnet_id
  network_rg_name    = module.network.network_rg_name
  acr_dns_zone_name  = module.network.acr_dns_zone_name
  node_size          = var.node_size
  aks_cluster_name   = var.aks_cluster_name
  dns_prefix         = var.dns_prefix
  aks_service_cidr   = var.aks_service_cidr
  kube_dns_ip        = var.kube_dns_ip
  appgw_id           = module.network.appgw_id
  jumphost_ssh_key   = module.storage.jumphost_ssh_public_key
}


module "network" {
  source = "./modules/network"

  location          = var.location
  acr_registry_name = var.acr_registry_name
}

module "storage" {
  source = "./modules/storage"

  location = var.location
}