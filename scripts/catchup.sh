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

# See if there's a catchup directory for this lab
if ! [ -d /tmp/terraform-azure-labs/lab_answers/${LAB} ]; then
  echo "Automatic catchup is not supported for lab ${LAB}"
  exit 1
fi

# Clean up and attempt a terraform destroy if needed
echo "Resetting your environment to the end of lab $LAB"
if ! [ -d /root/sandbox ]; then
  echo "Sandbox directory not detected. Creating now."
  mkdir -p /root/sandbox
  cd /root/sandbox
else
  echo "Sandbox directory found, performing cleanup."
  cd /root/sandbox
  rm -rf *.tf
  rm -rf *.tfvars
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

# Copy the completed exercise files into the sandbox directory.
cp -r /tmp/terraform-azure-labs/lab_answers/${LAB}/* /root/sandbox
terraform init
terraform apply -auto-approve

echo "**********************************************************************"
echo "All caught up. Your environment has been reset to the end of lab $LAB."
echo "**********************************************************************"