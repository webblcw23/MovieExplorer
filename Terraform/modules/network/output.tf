# Outputs

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}


output "subnet_ids" {
  value = {
    frontend             = azurerm_subnet.subnet-frontend.id
    backend              = azurerm_subnet.subnet-backend.id
    db                   = azurerm_subnet.subnet-db.id
    frontend_integration = azurerm_subnet.frontend_integreation_subnet.id
  }
}
