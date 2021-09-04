# Outputs file
output "catapp_url" {
  value = "http://${azurerm_public_ip.tflab_pip.fqdn}"
}

output "dad_joke" {
  value = local.json_data.joke
}

output "linux_vm_public_name" {
  value = module.linuxservers.public_ip_dns_name
}