output "azure_resource_group_id" {
  value = data.azurerm_resource_group.rg.id
}
output "azure_virtual_network_id" {
  value = data.azurerm_virtual_network.network.id
}
output "azure_subnet_id" {
  value = data.azurerm_subnet.subnet.id
}
output "azure_mssql_id" {
  value = azurerm_mssql_server.mssql.id
}
