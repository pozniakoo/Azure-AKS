provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}
#get tenant ID
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "key_vault_rg" {
  name     = "storage-rg"
  location = var.location
}

resource "azurerm_key_vault" "akv" {
  name                        = "akv"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.key_vault_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    /*secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]*/
  }
}

resource "azurerm_key_vault_secret" "jumphost01_ssh_key" {
  name         = "jumphost01-ssh-pubkey"
  value        = file("~/.ssh/id_rsa.pub")
  content_type = "text/plain"
  key_vault_id = azurerm_key_vault.akv.id
}