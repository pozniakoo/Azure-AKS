resource "azurerm_resource_group" "network_rg" {
  name     = "network-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "aks-vnet-10.0.0.0_23"
  location            = var.location
  resource_group_name = azurerm_resource_group.network_rg.name
  address_space       = ["10.0.0.0/23"]

  subnet {
    name             = "aks-subnet-10.0.0.0_24"
    address_prefixes = ["10.0.0.0/24"]
  }

  subnet {
    name             = "appgw-subnet-10.0.1.0_28"
    address_prefixes = ["10.0.1.0/28"]
  }

  subnet {
    name             = "privendpoint-subnet-10.0.1.16_29"
    address_prefixes = ["10.0.1.16/29"]
    private_endpoint_network_policies = "Disabled"
  }
}

