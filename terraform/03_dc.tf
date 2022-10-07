resource "azurerm_public_ip" "dc" {
  name                = "pip-${var.dc_name}"
  sku                 = var.pip_sku
  location            = azurerm_resource_group.dc.location
  resource_group_name = azurerm_resource_group.dc.name
  allocation_method   = var.pip_allocation_method 
}

resource "azurerm_network_interface" "dc" {
  name                = "nic-${var.dc_name}"
  location            = azurerm_resource_group.dc.location
  resource_group_name = azurerm_resource_group.dc.name
  dns_servers         = var.dns_servers

  ip_configuration {
    name                          = "ipconfig-${var.dc_name}"
    subnet_id                     = azurerm_subnet.dc.id
    public_ip_address_id          = azurerm_public_ip.dc.id
    private_ip_address_allocation = var.private_ip_address_allocation

  }
}


resource "azurerm_network_security_group" "dc" {
  name                = "nsg-${var.dc_name}"
  location            = azurerm_resource_group.dc.location
  resource_group_name = azurerm_resource_group.dc.name

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

resource "azurerm_network_interface_security_group_association" "dc" {
  network_interface_id      = azurerm_network_interface.dc.id
  network_security_group_id = azurerm_network_security_group.dc.id
}

resource "random_password" "dc" {
  length           = 16
  special          = true
  override_special = "!#?"
}

resource "azurerm_windows_virtual_machine" "dc" {
  name                = "vm-${var.dc_name}"
  resource_group_name = azurerm_resource_group.dc.name
  location            = azurerm_resource_group.dc.location
  size                = var.vm_size
  admin_username      = var.admin_username 
  admin_password      = random_password.dc.result
  network_interface_ids = [
    azurerm_network_interface.dc.id,
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

resource "azurerm_virtual_machine_extension" "windows_bootstrap" {
  name                 = var.vm_ext_name
  publisher            = var.vm_ext_publisher
  type                 = var.vm_ext_type
  type_handler_version = var.vm_ext_type_handler_version
  virtual_machine_id   = azurerm_windows_virtual_machine.dc.id

  protected_settings = <<SETTINGS
      {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
    }

  SETTINGS
}