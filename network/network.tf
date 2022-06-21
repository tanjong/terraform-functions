resource "azurerm_resource_group" "devopslab_general_rg" {
  name     = "devopslab_general_resource"
  location = "Central US"
}

resource "azurerm_network_security_group" "devopslab_general_rg" {
  name                = "devopslab_nsg"
  location            = azurerm_resource_group.devopslab_general_rg.location
  resource_group_name = azurerm_resource_group.devopslab_general_rg.name
}

resource "azurerm_virtual_network" "devopslab_general_rg" {
  name                = "devopslab_vnet"
  location            = azurerm_resource_group.devopslab_general_rg.location
  resource_group_name = azurerm_resource_group.devopslab_general_rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "database_subnet"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.devopslab_general_rg.id
  }

  subnet {
    name           = "application_subnet"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.devopslab_general_rg.id
  }

  tags = {
    environment = "Production"
    company     = "main admin"
    managedWith = "terraform"
  }
}

resource "azurerm_route_table" "devopslab_rt_rg" {
  name                          = "devopslab_rt"
  location                      = azurerm_resource_group.devopslab_general_rg.location
  resource_group_name           = azurerm_resource_group.devopslab_general_rg.name
  disable_bgp_route_propagation = false

  route {
    name           = "vnet_rt"
    address_prefix = "10.1.0.0/16"
    next_hop_type  = "VnetLocal"
  }

  tags = {
    environment = "Production"
    company     = "main admin"
    managedWith = "terraform"
  }
}