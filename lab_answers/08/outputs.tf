# Copyright IBM Corp. 2021, 2026

output "subnet_name" {
  value = azurerm_subnet.tflab_sn.name
}

output "subnet_id" {
  value = azurerm_subnet.tflab_sn.id
}