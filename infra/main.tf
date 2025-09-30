locals {
rg_name = "${var.project_name}-rg"
env_name = "${var.project_name}-aca-env"
sql_name = "${var.project_name}-sqlsvr"
db_name = "${var.project_name}db"
}
resource "azurerm_resource_group" "rg" {
name = local.rg_name
location = var.location
}
module "network" {
source = "./modules/network"
resource_group_name = azurerm_resource_group.rg.name
location = azurerm_resource_group.rg.location
vnet_name = "${var.project_name}-vnet"
vnet_cidr = var.vnet_cidr
subnet_aca_name = "aca-subnet"
subnet_aca_cidr = var.subnet_aca_cidr
subnet_pe_name = "pe-subnet"
subnet_pe_cidr = var.subnet_pe_cidr
}
module "sql" {
source = "./modules/sql"
resource_group_name = azurerm_resource_group.rg.name
location = azurerm_resource_group.rg.location
server_name = local.sql_name
database_name = local.db_name
admin_login = var.sql_admin_login
admin_password = var.sql_admin_password
private_endpoint_subnet_id= module.network.subnet_pe_id
private_dns_zone_id = module.network.private_dns_zone_id
}
module "aca" {
source = "./modules/aca"
resource_group_name = azurerm_resource_group.rg.name
location = azurerm_resource_group.rg.location
3
env_name = local.env_name
infra_subnet_id = module.network.subnet_aca_id
AcrPull + MI سجل الصور وسحبه عبر #
acr_id = var.acr_id
acr_login_server = var.acr_login_server
backend = {
name = "${var.project_name}-backend"
image = var.backend_image
port = var.backend_port
env = {
DB_SERVER = module.sql.sql_server_fqdn
DB_NAME = module.sql.database_name
DB_USER = var.sql_admin_login
}
secrets = {
DB_PASSWORD = var.sql_admin_password
}
external_ingress = true
}
frontend = {
name = "${var.project_name}-frontend"
image = var.frontend_image
port = var.frontend_port
env = {
REACT_APP_API_URL = "https://${module.aca.backend_fqdn}"
VITE_API_URL = "https://${module.aca.backend_fqdn}"
}
secrets = {}
external_ingress = true
}
}
