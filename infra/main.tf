terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}


# موارد مؤقتة فقط عشان تختبر
resource "azurerm_resource_group" "rg" {
  name     = "test-rg"
  location = "westeurope"
}

