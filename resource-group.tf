resource "azurerm_resource_group" "this" {
  name     = "fleet_rg_1"
  location = var.location_one
}

resource "azurerm_resource_group" "rg_2" {
  name     = "fleet_rg_2"
  location = var.location_two
}