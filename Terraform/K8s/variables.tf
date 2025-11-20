variable "location"{
    description = "Resource location"
    type = string
}

variable "rg_name" {
  description = "Resource Group name"
  type = string
}

variable "acr_registry_name" {
  description = "Azure Container Registry name"
  type = string
}

variable "vnet_id" {
  description = "Virtual network ID"
  type = string
}

variable "aks_subnet_id" {
  description = "ID of the subnet for AKS cluster"
  type = string
}

variable "pe_subnet_id" {
  description = "ID of the subnet for private endpoint"
  type = string
}

variable "network_rg_name" {
  description = "Resource group where network is placed"
  type = string
}

variable "acr_dns_zone_name" {
  description = "DNS zone name for ACR"
  type = string
}

variable "node_size" {
  description = "Default node size used by AKS cluster"
  type = string
}

variable "aks_cluster_name" {
  description = "Name for AKS cluster"
  type = string
}

variable "dns_prefix" {
  description = "DNS prefix"
  type = string
}

variable "aks_service_cidr" {
  description = "Subnet CIDR that will be used for AKS services. Can't colidate with VNet CIDR"
  type = string
}

variable "kube_dns_ip" {
  description = "kube-dns IP address"
  type = string
}