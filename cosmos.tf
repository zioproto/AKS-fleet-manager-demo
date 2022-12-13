# Private DNS Zone for SQL API in both vnets
resource "azurerm_private_dns_zone" "dns_zone_one" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "zone_link_one" {
  name                  = "sqlapi_zone_link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone_one.name
  virtual_network_id    = module.vnet_one.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone" "dns_zone_two" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = azurerm_resource_group.rg_2.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "zone_link_two" {
  name                  = "sqlapi_zone_link"
  resource_group_name   = azurerm_resource_group.rg_2.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone_two.name
  virtual_network_id    = module.vnet_two.vnet_id
  registration_enabled  = false
}

# Cosmos DB
module "azure_cosmos_db" {
  source              = "Azure/cosmosdb/azurerm"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  cosmos_account_name = var.cosmos_account_name
  cosmos_api          = var.cosmos_api
  multi_region_write  = var.multi_region_write
  geo_locations       = var.geo_locations
  sql_dbs             = var.sql_dbs
  sql_db_containers   = var.sql_db_containers
  private_endpoint = {
    "pe_endpoint" = {
      enable_private_dns_entry        = true
      dns_zone_group_name             = "pe_one_zone_group"
      dns_zone_rg_name                = azurerm_private_dns_zone.dns_zone_one.resource_group_name
      is_manual_connection            = false
      name                            = "pe_one"
      private_service_connection_name = "pe_one_connection"
      subnet_name                     = "subnet0"
      vnet_name                       = module.vnet_one.vnet_name
      vnet_rg_name                    = azurerm_resource_group.this.name
    }
    "pe_endpoint_two" = {
      enable_private_dns_entry        = false
      dns_zone_group_name             = "pe_two_zone_group"
      dns_zone_rg_name                = azurerm_private_dns_zone.dns_zone_two.resource_group_name
      is_manual_connection            = false
      name                            = "pe_two"
      private_service_connection_name = "pe_two_connection"
      subnet_name                     = "subnet0"
      vnet_name                       = module.vnet_two.vnet_name
      vnet_rg_name                    = azurerm_resource_group.rg_2.name
    }
  }
  depends_on = [
    azurerm_resource_group.this,
    azurerm_private_dns_zone.dns_zone_one,
    azurerm_private_dns_zone.dns_zone_two,
  ]
}