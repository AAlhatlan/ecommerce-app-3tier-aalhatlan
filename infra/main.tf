terraform {
  required_version = ">= 1.5.0"

}




# 🟦 إنشاء Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# 🌐 استدعاء Module الشبكة
module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
}

# 🧰 استدعاء Module ACA (Backend + Frontend)
module "aca" {
  source = "./modules/aca"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  backend_image       = var.backend_image
  frontend_image      = var.frontend_image
  project_name        = var.project_name
}

# 🗄️ استدعاء Module SQL
module "sql" {
  source = "./modules/sql"

  project_name         = var.project_name
  resource_group_name  = var.resource_group_name
  location             = var.location
  sql_admin_login      = var.sql_admin_login
  sql_admin_password   = var.sql_admin_password
  sql_pe_subnet_id     = var.sql_pe_subnet_id
  private_dns_zone_name = var.private_dns_zone_name
}




