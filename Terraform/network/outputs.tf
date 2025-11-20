output "vnet_id" {
  description = "ID of VNet"
  value = azurerm_virtual_network.vnet.id
}

output "aks_subnet_id" {
  value = [for subnet in azurerm_virtual_network.vnet.subnet : subnet.id if subnet.name == "aks-subnet-10.0.0.0_24"][0]
}

output "pe_subnet_id" {
  value = [for subnet in azurerm_virtual_network.vnet.subnet : subnet.id if subnet.name == "privendpoint-subnet-10.0.1.16_29"][0]
}

output "network_rg_name" {
  value = azurerm_resource_group.network_rg.name
}

output "acr_dns_zone_name" {
  value = azurerm_private_dns_zone.acr_dns.name
}