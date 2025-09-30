#!/bin/bash

# 🏗️ إنشاء مجلدات الموديولات
mkdir -p modules/network modules/sql modules/aca

# 📄 network/main.tf
cat > modules/network/main.tf <<'EOF'
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "aca_subnet" {
  name                 = "aca-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.App/environments"
    }
  }
}

resource "azurerm_subnet" "sql_pe_subnet" {
  name                 = "sql-pe-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_private_dns_zone" "sql_zone" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql_zone_link" {
  name                  = "${var.project_name}-sql-dnslink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
EOF

# 📄 network/variables.tf
cat > modules/network/variables.tf <<'EOF'
variable "project_name" {}
variable "resource_group_name" {}
variable "location" {}
EOF

# 📄 network/outputs.tf
cat > modules/network/outputs.tf <<'EOF'
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
EOF

# 📄 sql/main.tf
cat > modules/sql/main.tf <<'EOF'
resource "azurerm_mssql_server" "sql" {
  name                         = "${var.project_name}-sqlserver"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
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
EOF

# 📄 sql/variables.tf
cat > modules/sql/variables.tf <<'EOF'
variable "project_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "sql_admin_login" {}
variable "sql_admin_password" {}
variable "sql_pe_subnet_id" {}
variable "private_dns_zone_name" {}
EOF

# 📄 sql/outputs.tf
cat > modules/sql/outputs.tf <<'EOF'
output "sql_fqdn" {
  value = azurerm_mssql_server.sql.fully_qualified_domain_name
}
EOF

# 📄 aca/main.tf
cat > modules/aca/main.tf <<'EOF'
resource "azurerm_container_app_environment" "aca_env" {
  name                = "${var.project_name}-aca-env"
  location            = var.location
  resource_group_name = var.resource_group_name
  infrastructure_subnet_id = var.aca_subnet_id
}

resource "azurerm_container_app" "backend" {
  name                         = "${var.project_name}-be"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = "backend"
      image  = var.backend_image
      cpu    = 0.5
      memory = "1Gi"
      env {
        name  = "DB_SERVER"
        value = var.sql_fqdn
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 3001
  }
}

resource "azurerm_container_app" "frontend" {
  name                         = "${var.project_name}-fe"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = "frontend"
      image  = var.frontend_image
      cpu    = 0.5
      memory = "1Gi"
      env {
        name  = "API_URL"
        value = azurerm_container_app.backend.ingress[0].fqdn
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 3000
  }
}
EOF

# 📄 aca/variables.tf
cat > modules/aca/variables.tf <<'EOF'
variable "project_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "aca_subnet_id" {}
variable "backend_image" {}
variable "frontend_image" {}
variable "sql_fqdn" {}
EOF

# 📄 aca/outputs.tf
cat > modules/aca/outputs.tf <<'EOF'
output "frontend_fqdn" {
  value = azurerm_container_app.frontend.ingress[0].fqdn
}
output "backend_fqdn" {
  value = azurerm_container_app.backend.ingress[0].fqdn
}
EOF

echo "✅ Terraform modules (network, sql, aca) created successfully."
