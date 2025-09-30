output "resource_group" { value = azurerm_resource_group.rg.name }
output "frontend_fqdn" { value = module.aca.frontend_fqdn }
output "backend_fqdn" { value = module.aca.backend_fqdn }
output "sql_fqdn" { value = module.sql.sql_server_fqdn }
output "sql_db" { value = module.sql.database_name }