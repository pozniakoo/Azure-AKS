variable "location" {
  description = "Azure region"
}

variable "state_rg" {
  description = "RG Name where tfstate will be stored"
}

variable "storage_name" {
  description = "Name of storage account"
}

variable "container_name" {
  description = "Blob container name"
}

variable "subscription_id" {
  description = "Subscription ID"
}