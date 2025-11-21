output "jumphost_ssh_public_key" {
  description = "Public SSH key for jumphost, stored in AKV"
  value = azurerm_key_vault_secret.jumphost01_ssh_key.value
}