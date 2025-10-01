variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_prefix" {
  type        = string
  description = "Prefix for naming Azure resources"
}

variable "author" {
  type        = string
  description = "Author name to include in resource naming"
}

variable "resource_group_name" {
  type        = string
  description = "Azure Resource Group name"
}

variable "location" {
  type        = string
  description = "Azure Region"
}

variable "fe_image_name" {
  type        = string
  description = "Frontend Docker image name (e.g. aalhatlan/assignment-fe)"
}

variable "fe_tag" {
  type        = string
  description = "Docker image tag (e.g. latest)"
}

variable "be_image_name" {
  type        = string
  description = "backend Docker image name (e.g. aalhatlan/assignment-be)"
}

variable "be_tag" {
  type        = string
  description = "Docker image tag (e.g. latest)"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the existing Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
}

variable "sql_admin_login" {
  type        = string
  description = "Admin username for SQL Server"
  sensitive   = true
}

variable "sql_admin_password" {
  type        = string
  description = "Admin password for SQL Server"
  sensitive   = true
}
