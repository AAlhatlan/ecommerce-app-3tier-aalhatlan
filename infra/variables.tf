variable "project_name" { type = string }
variable "location" { type = string default = "westeurope" }
(CIيتم تحديث العالمات من الـ) صور الحاويات #
variable "backend_image" { type = string }
variable "frontend_image" { type = string }
منافذ الحاويات #
variable "backend_port" { type = number default = 3001 }
variable "frontend_port" { type = number default = 3000 }
# SQL Admin
variable "sql_admin_login" { type = string }
variable "sql_admin_password" { type = string sensitive = true }
PEللـ Subnet + ACAللـ Subnet + واحدة VNet :شبكة بسيطة #
variable "vnet_cidr" { type = string default = "10.70.0.0/16" }
variable "subnet_aca_cidr" { type = string default = "10.70.1.0/24" }
variable "subnet_pe_cidr" { type = string default = "10.70.2.0/24" }
(أو ننشئه هنا Terraform من خارج server_loginوالـ idنمرر الـ) ACR #
2
variable "acr_id" { type = string }
variable "acr_login_server" { type = string }