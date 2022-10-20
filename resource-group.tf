resource "azurerm_resource_group" "this" {
  name     = "fleet"
  location = var.location_one
}
