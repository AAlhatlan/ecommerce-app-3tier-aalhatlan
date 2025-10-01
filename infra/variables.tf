variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}



