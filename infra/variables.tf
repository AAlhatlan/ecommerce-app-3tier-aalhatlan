variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
}

variable "azure_credentials" {
  description = "JSON credentials for Azure Service Principal"
  type        = string
}
