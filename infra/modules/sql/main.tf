resource "azurerm_mssql_server" "sql" {
  name                          = "${var.project_name}-sqlserver"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.sql_admin_login
  administrator_login_password  = var.sql_admin_password
  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "db" {
  name      = "${var.project_name}-db"
  server_id = azurerm_mssql_server.sql.id
  sku_name  = "Basic"
}

resource "azurerm_private_endpoint" "sql_pe" {
  name                = "${var.project_name}-sql-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.sql_pe_subnet_id

  private_service_connection {
    name                           = "sqlConnection"
    private_connection_resource_id = azurerm_mssql_server.sql.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_a_record" "sql_record" {
  name                = azurerm_mssql_server.sql.name
  zone_name           = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sql_pe.private_service_connection[0].private_ip_address]
}
