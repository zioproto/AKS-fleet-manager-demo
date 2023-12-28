# Requires provider version 3.30.0 or later
# https://github.com/hashicorp/terraform-provider-azurerm/pull/19111
resource "azurerm_kubernetes_fleet_manager" "fleet" {
  name                = "contosofleet"
  location            = var.location_one
  resource_group_name = azurerm_resource_group.this.name
  hub_profile {
    dns_prefix = "fleetname"
  }
}

#https://learn.microsoft.com/en-us/azure/templates/microsoft.containerservice/fleets/members?pivots=deployment-language-terraform
# Requires https://github.com/hashicorp/terraform-provider-azurerm/issues/21468 to be fixed to drop azapi resources

resource "azapi_resource" "fleetmemberone" {
  depends_on = [ module.aksone ]
  type      = "Microsoft.ContainerService/fleets/members@2022-07-02-preview"
  name      = "contosofleetmember1"
  parent_id = azurerm_kubernetes_fleet_manager.fleet.id
  body = jsonencode({
    properties = {
      clusterResourceId = module.aksone.aks_id
    }
  })
}

resource "azapi_resource" "fleetmembertwo" {
  depends_on = [ module.akstwo ]
  type      = "Microsoft.ContainerService/fleets/members@2022-07-02-preview"
  name      = "contosofleetmember2"
  parent_id = azurerm_kubernetes_fleet_manager.fleet.id
  body = jsonencode({
    properties = {
      clusterResourceId = module.akstwo.aks_id
    }
  })
}
