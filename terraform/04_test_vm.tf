resource "azurerm_public_ip" "vm_spoke" {
  name                = "pip-${var.vm_spoke_name}"
  sku                 = var.pip_sku
  location            = azurerm_resource_group.vm_spoke.location
  resource_group_name = azurerm_resource_group.vm_spoke.name
  allocation_method   = var.pip_allocation_method
}

resource "azurerm_network_interface" "vm_spoke" {
  name                = "nic-${var.vm_spoke_name}"
  location            = azurerm_resource_group.vm_spoke.location
  resource_group_name = azurerm_resource_group.vm_spoke.name
  dns_servers         = var.dns_servers

  ip_configuration {
    name                          = "ipconfig-${var.vm_spoke_name}"
    subnet_id                     = azurerm_subnet.vm_spoke.id
    public_ip_address_id          = azurerm_public_ip.vm_spoke.id
    private_ip_address_allocation = var.private_ip_address_allocation
  }
}


resource "azurerm_network_security_group" "vm_spoke" {
  name                = "nsg-${var.vm_spoke_name}"
  location            = azurerm_resource_group.vm_spoke.location
  resource_group_name = azurerm_resource_group.vm_spoke.name

  security_rule {
    name                       = "allow rdp"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${var.management_ip}/32"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "vm_spoke" {
  network_interface_id      = azurerm_network_interface.vm_spoke.id
  network_security_group_id = azurerm_network_security_group.vm_spoke.id
}

resource "random_password" "vm_spoke" {
  length           = 16
  special          = true
  override_special = "!#?"
}

resource "azurerm_windows_virtual_machine" "vm_spoke" {
  name                = var.vm_spoke_name
  resource_group_name = azurerm_resource_group.vm_spoke.name
  location            = azurerm_resource_group.vm_spoke.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = random_password.vm_spoke.result
  network_interface_ids = [
    azurerm_network_interface.vm_spoke.id,
  ]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference_publisher
    offer     = var.source_image_reference_offer
    sku       = var.source_image_reference_sku
    version   = var.source_image_reference_version
  }
}
