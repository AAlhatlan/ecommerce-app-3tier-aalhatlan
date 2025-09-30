output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "aca_subnet_id" {
  value = azurerm_subnet.aca_subnet.id
}
output "sql_pe_subnet_id" {
  value = azurerm_subnet.sql_pe_subnet.id
}
output "private_dns_zone_name" {
  value = azurerm_private_dns_zone.sql_zone.name
}
