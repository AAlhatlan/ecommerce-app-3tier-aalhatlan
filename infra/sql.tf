resource "azurerm_mssql_server" "sql_server" {
  name                          = "ecommerce-sqlserver-aalhatlan"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.sql_admin_login
  administrator_login_password  = var.sql_admin_password
  public_network_access_enabled = true
}

resource "azurerm_mssql_database" "sql_database" {
  name      = "ecommerce_db"
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "Basic"
}


resource "azurerm_mssql_firewall_rule" "github_actions_access" {
  name             = "github-actions-access"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}
