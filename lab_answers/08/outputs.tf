# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: Apache-2.0

output "subnet_name" {
  value = azurerm_subnet.tflab_sn.name
}

output "subnet_id" {
  value = azurerm_subnet.tflab_sn.id
}