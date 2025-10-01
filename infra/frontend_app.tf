resource "azurerm_service_plan" "frontend_plan" {
  name                = "frontend-service-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1" 
}


resource "azurerm_linux_web_app" "frontend_app" {
  name                = "frontend-app-aalhatlan"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.frontend_plan.id

  site_config {
    application_stack {
      docker_image     = "aalhatlan/assignment-fe"
      docker_image_tag = "latest"
    }
  }

  app_settings = {
    WEBSITES_PORT = "80" 
  }
}
