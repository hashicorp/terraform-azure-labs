# Outputs file
output "catapp_url" {
  value = "http://${azurerm_public_ip.tflab-pip.fqdn}"
}

output "catapp_ip" {
  value = "http://${azurerm_public_ip.tflab-pip.ip_address}"
}