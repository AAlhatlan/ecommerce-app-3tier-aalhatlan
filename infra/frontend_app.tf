locals {
  fe_app_name          = "${lower(var.resource_prefix)}-fe-app-${lower(replace(var.author, " ", "-"))}"
  service_plan_name_fe = "${lower(var.resource_prefix)}-fe-service-plan-${lower(replace(var.author, " ", "-"))}"
  public_access        = true
  fe_sku               = "B1" # Basic plan
  fe_hostname          = "${local.fe_app_name}.azurewebsites.net"
}

#########################################
# 🧰 App Service Plan (Linux)
#########################################
resource "azurerm_service_plan" "frontend_plan" {
  name                = local.service_plan_name_fe
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Linux"
  sku_name            = local.fe_sku
}

#########################################
# 🚀 Frontend App Service (Linux Web App)
#########################################
resource "azurerm_linux_web_app" "frontend_app" {
  name                = local.fe_app_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  service_plan_id     = azurerm_service_plan.frontend_plan.id
  public_network_access_enabled = local.public_access

  site_config {
    always_on = true

    application_stack {
      docker_image_name   = "${var.fe_image_name}:${var.fe_tag}"
      docker_registry_url = "https://index.docker.io"
    }

    health_check_path                 = "/"
    health_check_eviction_time_in_min = 5
  }

  
  
}
