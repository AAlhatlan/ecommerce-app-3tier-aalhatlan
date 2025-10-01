locals {
  be_app_name          = "${lower(var.resource_prefix)}-be-app-${lower(replace(var.author, " ", "-"))}"
  service_plan_name_be = "${lower(var.resource_prefix)}-be-service-plan-${lower(replace(var.author, " ", "-"))}"
  public_access_be        = true
  be_sku               = "B1" # Basic plan
  be_hostname          = "${local.be_app_name}.azurewebsites.net"
}

#########################################
# 🧰 App Service Plan (Linux)
#########################################
resource "azurerm_service_plan" "backend_plan" {
  name                = local.service_plan_name_be
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = local.be_sku
}

#########################################
# 🚀 backend App Service (Linux Web App)
#########################################
resource "azurerm_linux_web_app" "backend_app" {
  name                = local.be_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.backend_plan.id
  public_network_access_enabled = local.public_access_be

  site_config {
    always_on = true

    application_stack {
      docker_image_name   = "${var.be_image_name}:${var.be_tag}"
      docker_registry_url = "https://index.docker.io"
    }

    health_check_path                 = "/"
    health_check_eviction_time_in_min = 5
  }

  
  
}
