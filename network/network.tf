resource "azurerm_resource_group" "devopslab_vnet_rg" {
  name     = "devopslab_vnet_rg"
  location = "Central US"
}

resource "azurerm_network_security_group" "devopslab_vnet_rg" {
  name                = "devopslab_nsg"
  location            = azurerm_resource_group.devopslab_vnet_rg.location
  resource_group_name = azurerm_resource_group.devopslab_vnet_rg.name
}

resource "azurerm_virtual_network" "devopslab_vnet_rg" {
  name                = "devopslab_vnet"
  location            = azurerm_resource_group.devopslab_vnet_rg.location
  resource_group_name = azurerm_resource_group.devopslab_vnet_rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "database_subnet"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.devopslab_vnet_rg.id
  }

  subnet {
    name           = "application_subnet"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.devopslab_vnet_rg.id
  }

  tags = {
    environment = "Production"
    company = "main admin"
    managedWith = "terraform"
  }
}