variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to resources"
}