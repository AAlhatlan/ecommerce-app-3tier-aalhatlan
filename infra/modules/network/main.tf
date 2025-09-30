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
