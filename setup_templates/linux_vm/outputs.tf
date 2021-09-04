# Outputs file
output "catapp_url" {
  value = "http://${azurerm_public_ip.tflab_pip.fqdn}"
}

output "catapp_ip" {
  value = "http://${azurerm_public_ip.tflab_pip.ip_address}"
}