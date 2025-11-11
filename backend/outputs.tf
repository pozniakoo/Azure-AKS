output "storage_account_name" {
  description = "tfstate storage account name"
  value       = azurerm_storage_account.tfstate-storage.name
}

output "rg_name" {
  description = "Storage account RG"
  value       = azurerm_resource_group.tfstate-rg.name
}

output "container_name" {
  description = "Container name"
  value       = azurerm_storage_container.tfstate-container.name
}