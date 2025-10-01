locals {
  # Backend naming convention
  be_app_name             = "${lower(var.resource_prefix)}-be-app-${lower(replace(var.author, " ", "-"))}"
  service_plan_name_be    = "${lower(var.resource_prefix)}-be-service-plan-${lower(replace(var.author, " ", "-"))}"
  public_access_be        = true
  be_sku                  = "B1" # Basic plan
  be_hostname             = "${local.be_app_name}.azurewebsites.net"

 # Frontend naming for dynamic CORS origin (for backend CORS)
frontend_app_name_for_cors = "${lower(var.resource_prefix)}-fe-app-${lower(replace(var.author, " ", "-"))}"
frontend_hostname_for_cors = "${local.frontend_app_name_for_cors}.azurewebsites.net"
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
# 🚀 Backend App Service (Linux Web App)
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

  app_settings = {
    # Basic runtime settings
    PORT                        = "80"
    NODE_ENV                    = "production"

    # Database configuration
    DB_SERVER                   = var.sql_server_fqdn
    DB_NAME                     = var.sql_database_name
    DB_USER                     = var.sql_admin_login
    DB_PASSWORD                 = var.sql_admin_password
    DB_ENCRYPT                  = "true"
    DB_TRUST_SERVER_CERTIFICATE = "false"
    DB_CONNECTION_TIMEOUT       = "30000"

    # JWT configuration
    JWT_SECRET                  = var.jwt_secret
    JWT_EXPIRES_IN              = "7d"

    #  CORS configuration - dynamically set to frontend hostname
    CORS_ORIGIN = "https://${local.frontend_hostname_for_cors}"

    # Rate limiting
    RATE_LIMIT_WINDOW_MS        = "900000"
    RATE_LIMIT_MAX_REQUESTS     = "100"
  }
}
