
resource "azurerm_service_plan" "frontend_plan" {
  name                = "frontend-service-plan-aalhatlan"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  os_type             = "Linux"
  sku_name            = "B1"   
}


resource "azurerm_linux_web_app" "frontend_app" {
  name                = "frontend-app-aalhatlan"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  service_plan_id     = azurerm_service_plan.frontend_plan.id

  site_config {
    application_stack {
      docker_image     = "aalhatlan/assignment-fe"  
      docker_image_tag = "latest"                   
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    DOCKER_REGISTRY_SERVER_URL          = "https://index.docker.io"  
  }

  identity {
    type = "SystemAssigned"
  }
}
