output "frontend_fqdn" {
  value = azurerm_container_app.frontend.ingress[0].fqdn
}
output "backend_fqdn" {
  value = azurerm_container_app.backend.ingress[0].fqdn
}
