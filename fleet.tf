# All the code in this file requires the preview feature to be enabled:
# az feature register --namespace Microsoft.ContainerService --name FleetResourcePreview

#https://learn.microsoft.com/en-us/azure/templates/microsoft.containerservice/fleets?pivots=deployment-language-terraform

resource "azapi_resource" "fleet" {
  type      = "Microsoft.ContainerService/fleets@2022-07-02-preview"
  name      = "contosofleet"
  location  = var.location_one
  parent_id = azurerm_resource_group.this.id

  body = jsonencode({
    properties = {
      hubProfile = {
        dnsPrefix = "fleetname"
      }
    }
  })
}


#https://learn.microsoft.com/en-us/azure/templates/microsoft.containerservice/fleets/members?pivots=deployment-language-terraform

resource "azapi_resource" "fleetmemberone" {
  type      = "Microsoft.ContainerService/fleets/members@2022-07-02-preview"
  name      = "contosofleetmember1"
  parent_id = azapi_resource.fleet.id
  body = jsonencode({
    properties = {
      clusterResourceId = module.aksone.aks_id
    }
  })
}

resource "azapi_resource" "fleetmembertwo" {
  type      = "Microsoft.ContainerService/fleets/members@2022-07-02-preview"
  name      = "contosofleetmember2"
  parent_id = azapi_resource.fleet.id
  body = jsonencode({
    properties = {
      clusterResourceId = module.akstwo.aks_id
    }
  })
}
