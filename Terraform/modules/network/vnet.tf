resource "azurerm_resource_group" "network_rg" {
  name     = "network-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-10.0.0.0_23"
  location            = var.location
  resource_group_name = azurerm_resource_group.network_rg.name
  address_space       = ["10.0.0.0/23"]

  subnet {
    #subnet used by AKS
    name             = "aks-subnet-10.0.0.0_24"
    address_prefixes = ["10.0.0.0/24"]
  }

  subnet {
    #subnet for Appgw
    name             = "appgw-subnet-10.0.1.0_28"
    address_prefixes = ["10.0.1.0/28"]
  }

  subnet {
    #subnet for PE
    name             = "privendpoint-subnet-10.0.1.16_29"
    address_prefixes = ["10.0.1.16/29"]
    private_endpoint_network_policies = "Disabled"
  }
  
  subnet {
    #subnet for Bastion
    name = "AzureBastionSubnet"
    address_prefixes = ["10.0.1.32/27"]
  }

  subnet {
    name = "jumphost-subnet-10.0.1.48/29"
    address_prefixes = ["10.0.1.64/29"]
  }
}

resource "azurerm_public_ip" "natgw_pip" {
  name                = "nat-gateway-pip"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = var.location
  allocation_method   = "Static"
  sku = "Standard"

  tags = {
    usage = "Public IP for AKS outbound connection"
  }
}

resource "azurerm_nat_gateway" "natgw" {
  name                    = "aks-nat-gateway"
  location                = var.location
  resource_group_name     = azurerm_resource_group.network_rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4
}


resource "azurerm_nat_gateway_public_ip_association" "natgw_pip_association" {
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = azurerm_public_ip.natgw_pip.id
}

resource "azurerm_subnet_nat_gateway_association" "natgw_subnet_association" {
  subnet_id      = [for subnet in azurerm_virtual_network.vnet.subnet : subnet.id if subnet.name == "aks-subnet-10.0.0.0_24"][0]
  nat_gateway_id = azurerm_nat_gateway.natgw.id
}

resource "azurerm_public_ip" "appgw_pip" {
  name                = "app-gateway-pip"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = var.location
  allocation_method   = "Static"
  sku = "Standard"
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.vnet.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.vnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vnet.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.vnet.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.vnet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.vnet.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.vnet.name}-rdrcfg"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "aks-app-gateway"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "ip-config"
    subnet_id = [for subnet in azurerm_virtual_network.vnet.subnet : subnet.id if subnet.name == "appgw-subnet-10.0.1.0_28"][0]
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}