variable "subscription_id" {
  description = "Azure subscription ID"
  type = string
}

variable "location" {
  description = "Resource location"
  type = string
}

variable "acr_registry_name" {
  description = "Azure Container Registry Name"
  type = string
}

variable "node_size" {
  description = "Node size used by AKS cluster"
  type = string
}

variable "aks_cluster_name" {
  description = "AKS cluster name"
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