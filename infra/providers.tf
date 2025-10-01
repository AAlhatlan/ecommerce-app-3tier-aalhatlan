terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.46.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.7.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }
}

provider "azurerm" {
  # Configuration options

  features {

  }

  subscription_id = var.subscription_id
}

provider "random" {
}

provider "tls" {

}