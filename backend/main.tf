terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.1.0"
    }
  }
  backend "azurerm"{
    resource_group_name = "tfstate-rg"
    storage_account_name = "szymon-tfstate-storage"
    container_name = "tfstate"
    key = "backend-state.tfstate"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}



resource "random_integer" "random" {
  min = 100
  max = 999
}

resource "azurerm_resource_group" "tfstate-rg" {
  name     = var.state_rg
  location = var.location
}


resource "azurerm_storage_account" "tfstate-storage" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.tfstate-rg.name
  location                 = azurerm_resource_group.tfstate-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate-container" {
  name                  = var.container_name
  storage_account_id = azurerm_storage_account.tfstate-storage.id
  container_access_type = "private"
}