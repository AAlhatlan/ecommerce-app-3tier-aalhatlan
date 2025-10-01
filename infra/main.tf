terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 🚫 تعطيل الموديولات مؤقتًا
# module "aca" {
#   source = "./modules/aca"
#   # arguments...
# }

# module "sql" {
#   source = "./modules/sql"
#   # arguments...
# }

resource "azurerm_resource_group" "rg" {
  name     = "temporary-rg"
  location = "westeurope"
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}
