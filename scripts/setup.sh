#!/bin/bash
set -e
LAB=$1

# Zero pad our lab number
LAB=$(printf "%02d\n" $LAB)

# Basic test to check for a single integer argument.
if [ "$#" -ne 1 ] || ! [[ "$LAB"  =~ ^-?[0-9]+$ ]]; then
 echo "Usage: $0 <LABNUMBER>"
 exit 1
fi

# See if there's a setup directory for this lab
if ! [ -d /tmp/terraform-azure-labs/setup_templates/${LAB} ]; then
  echo "Automatic setup is not supported for lab ${LAB}"
  exit 1
fi

# Clean up and attempt a terraform destroy if needed
echo "Setting up your environment for lab $LAB"
if ! [ -d /root/sandbox ]; then
  echo "Sandbox directory not detected. Creating now."
  mkdir -p /root/sandbox
  cd /root/sandbox
else
  echo "Sandbox directory found, performing cleanup."
  cd /root/sandbox
  rm -f *.tf
  rm -f *.tfvars
  rm -f .terraform.lock.hcl
  # Need a minimum configuration to be able to destroy
cat <<-EOM > /root/sandbox/main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}
EOM
  terraform init
  terraform destroy -auto-approve
fi

# Wipe the sandbox directory completely clean
rm -rf /root/sandbox/*

# Copy the setup files into the sandbox directory.
cp -r /tmp/terraform-azure-labs/setup_templates/${LAB}/* /root/sandbox
terraform init

echo "**********************************************************************"
echo "Your environment is now set up and ready for lab $LAB."
echo "**********************************************************************"