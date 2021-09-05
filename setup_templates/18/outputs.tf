# Outputs file
output "catapp_url" {
  value = "http://${azurerm_public_ip.tflab_pip.fqdn}"
}

output "dad_joke" {
  value = local.json_data.joke
}