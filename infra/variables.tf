variable "project_name" {
  description = "اسم المشروع"
  type        = string
}

variable "resource_group_name" {
  description = "اسم مجموعة الموارد"
  type        = string
}

variable "location" {
  description = "موقع النشر"
  type        = string
  default     = "westeurope"
}

variable "backend_image" {
  description = "رابط صورة الباكند على DockerHub"
  type        = string
}

variable "frontend_image" {
  description = "رابط صورة الفرونت على DockerHub"
  type        = string
}

variable "sql_admin_login" {
  description = "اسم مستخدم SQL Server"
  type        = string
}

variable "sql_admin_password" {
  description = "كلمة مرور SQL Server"
  type        = string
  sensitive   = true
}
