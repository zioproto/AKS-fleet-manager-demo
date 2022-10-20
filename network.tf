module "vnet_one" {
  source              = "git::https://github.com/lonegunmanb/terraform-azurerm-subnets.git"
  resource_group_name = azurerm_resource_group.this.name
  subnets = {
    subnet0 = {
      address_prefixes = ["10.52.0.0/16"]
    }
  }
  virtual_network_address_space = ["10.52.0.0/16"]
  virtual_network_location      = var.location_one
  virtual_network_name          = "vnet1"
}

module "vnet_two" {
  source              = "git::https://github.com/lonegunmanb/terraform-azurerm-subnets.git"
  resource_group_name = azurerm_resource_group.this.name
  subnets = {
    subnet0 = {
      address_prefixes = ["10.53.0.0/16"]
    }
  }
  virtual_network_address_space = ["10.53.0.0/16"]
  virtual_network_location      = var.location_two
  virtual_network_name          = "vnet2"
}

resource "azurerm_virtual_network_peering" "onetotwo" {
  name                      = "onetotwo"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = module.vnet_one.vnet_name
  remote_virtual_network_id = module.vnet_two.vnet_id
}

resource "azurerm_virtual_network_peering" "twotoone" {
  name                      = "twotoone"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = module.vnet_two.vnet_name
  remote_virtual_network_id = module.vnet_one.vnet_id
}