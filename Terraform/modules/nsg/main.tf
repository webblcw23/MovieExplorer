# NSGs

# NSG for Frontend subnet
resource "azurerm_network_security_group" "frontend_nsg" {
  name                = "frontend_nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

    security_rule {
        name                       = "AllowHTTPInbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

}

# NSG for Backend subnet
resource "azurerm_network_security_group" "backend_nsg" {
  name                = "backend_nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

security_rule {
  name                       = "AllowFrontendToBackend"
  priority                   = 110
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_address_prefix      = "10.0.1.0/24" # frontend subnet CIDR
  source_port_range          = "*"
  destination_address_prefix = "*"          # or "VirtualNetwork"
  destination_port_range     = "8080"       # backend app port
}
}

# NSG for Database subnet
resource "azurerm_network_security_group" "db_nsg" {
  name                = "database_nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

    security_rule {
        name                       = "AllowBackendToDB"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "10.0.2.0/24" # Backend subnet address space
        destination_address_prefix = "*"
    }

}


# Link NSGs to actual subnets

#Link frontend nsg to frontend subnet
resource "azurerm_subnet_network_security_group_association" "frontend_nsg_association" {
  subnet_id                 = var.frontend_subnet_id
  network_security_group_id = azurerm_network_security_group.frontend_nsg.id
}
#Link backend nsg to backend subnet
resource "azurerm_subnet_network_security_group_association" "backend_nsg_association" {
  subnet_id                 = var.backend_subnet_id
  network_security_group_id = azurerm_network_security_group.backend_nsg.id
}
#Link db nsg to db subnet
resource "azurerm_subnet_network_security_group_association" "db_nsg_association" {
  subnet_id                 = var.db_subnet_id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}