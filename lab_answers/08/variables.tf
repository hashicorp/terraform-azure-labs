# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: Apache-2.0

variable "location" {
  default     = "Central US"
  description = "Azure location where resources should be built."
}

variable "owner" {
  default     = "Your Name"
  description = "Owner of the resource."
}