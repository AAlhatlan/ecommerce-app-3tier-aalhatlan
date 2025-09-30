resource "azurerm_container_app_environment" "aca_env" {
  name                = "${var.project_name}-aca-env"
  location            = var.location
  resource_group_name = var.resource_group_name
  infrastructure_subnet_id = var.aca_subnet_id
}

resource "azurerm_container_app" "backend" {
  name                         = "${var.project_name}-be"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = "backend"
      image  = var.backend_image
      cpu    = 0.5
      memory = "1Gi"
      env {
        name  = "DB_SERVER"
        value = var.sql_fqdn
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 3001
  }
}

resource "azurerm_container_app" "frontend" {
  name                         = "${var.project_name}-fe"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = "frontend"
      image  = var.frontend_image
      cpu    = 0.5
      memory = "1Gi"
      env {
        name  = "API_URL"
        value = azurerm_container_app.backend.ingress[0].fqdn
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 3000
  }
}
