resource "azurerm_resource_group" "jumphost_rg" {
  name     = "jumphost-rg"
  location = var.location
}


resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastionpip"
  resource_group_name = azurerm_resource_group.jumphost_rg.name
  location            = var.location
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-host"
  location            = var.location
  resource_group_name = azurerm_resource_group.jumphost_rg.name
  sku = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "jumphost01" {
  name                = "jumphost01"
  resource_group_name = azurerm_resource_group.jumphost_rg.name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.jumphost01-nic.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = azurerm_key_vault_secret.jumphost01_ssh_key.value
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "jumphost01-nic" {
  name                = "jumphost01-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.jumphost_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.jumphost_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}