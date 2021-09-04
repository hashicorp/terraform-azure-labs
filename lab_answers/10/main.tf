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

resource "random_pet" "tflab_pet" {
  length = 2
}

resource "azurerm_resource_group" "tflab_rg" {
  name     = "${random_pet.tflab_pet.id}-resource-group"
  location = var.location
}

resource "azurerm_virtual_network" "tflab_vn" {
  name                = "${random_pet.tflab_pet.id}-virtual-network"
  location            = azurerm_resource_group.tflab_rg.location
  resource_group_name = azurerm_resource_group.tflab_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "tflab_sn" {
  name                 = "${random_pet.tflab_pet.id}-subnet"
  resource_group_name  = azurerm_resource_group.tflab_rg.name
  virtual_network_name = azurerm_virtual_network.tflab_vn.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "tflab_sg" {
  name                = "${random_pet.tflab_pet.id}-security-group"
  location            = azurerm_resource_group.tflab_rg.location
  resource_group_name = azurerm_resource_group.tflab_rg.name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "tflab_nic" {
  name                = "${random_pet.tflab_pet.id}-nic"
  location            = azurerm_resource_group.tflab_rg.location
  resource_group_name = azurerm_resource_group.tflab_rg.name

  ip_configuration {
    name                          = "${random_pet.tflab_pet.id}-ipconfig"
    subnet_id                     = azurerm_subnet.tflab_sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tflab_pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "tflab_sg_ass" {
  network_interface_id      = azurerm_network_interface.tflab_nic.id
  network_security_group_id = azurerm_network_security_group.tflab_sg.id
}

resource "azurerm_public_ip" "tflab_pip" {
  name                = "${random_pet.tflab_pet.id}-pip"
  location            = azurerm_resource_group.tflab_rg.location
  resource_group_name = azurerm_resource_group.tflab_rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${random_pet.tflab_pet.id}-meow"
}

resource "azurerm_linux_virtual_machine" "tflab_linux_vm" {
  name                = "${random_pet.tflab_pet.id}-server"
  resource_group_name = azurerm_resource_group.tflab_rg.name
  location            = azurerm_resource_group.tflab_rg.location
  size                = "Standard_A2_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.tflab_nic.id,
  ]

  disable_password_authentication = false
  admin_password                  = "HashiCorp123"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

}