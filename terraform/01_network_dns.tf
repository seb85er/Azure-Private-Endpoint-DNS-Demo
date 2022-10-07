resource "azurerm_resource_group" "dc" {
  name     = "rg-${var.dc_name}"
  location = var.location
}

resource "azurerm_resource_group" "vm_spoke" {
  name     = "rg-${var.vm_spoke_name}"
  location = var.location
}

resource "azurerm_resource_group" "pe_spoke" {
  name     = "rg-${var.private_endpoint_spoke_name}"
  location = var.location
}

resource "azurerm_virtual_network" "dc" {
  name                = var.dc_name
  address_space       = var.dc_address_space
  location            = azurerm_resource_group.dc.location
  resource_group_name = azurerm_resource_group.dc.name
  dns_servers         = var.dns_servers
}

resource "azurerm_subnet" "dc" {
  name                                          = var.dc_name
  resource_group_name                           = azurerm_resource_group.dc.name
  virtual_network_name                          = azurerm_virtual_network.dc.name
  address_prefixes                              = var.dc_subnet
  private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled
}

resource "azurerm_virtual_network" "vm_spoke" {
  name                = var.vm_spoke_name
  address_space       = var.vm_address_space
  location            = azurerm_resource_group.vm_spoke.location
  resource_group_name = azurerm_resource_group.vm_spoke.name
  dns_servers         = var.dns_servers
}

resource "azurerm_subnet" "vm_spoke" {
  name                                          = var.vm_spoke_name
  resource_group_name                           = azurerm_resource_group.vm_spoke.name
  virtual_network_name                          = azurerm_virtual_network.vm_spoke.name
  address_prefixes                              = var.vm_subnet
  private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled
}

resource "azurerm_virtual_network" "pe_spoke" {
  name                = var.private_endpoint_spoke_name
  address_space       = var.pe_address_space
  location            = azurerm_resource_group.pe_spoke.location
  resource_group_name = azurerm_resource_group.pe_spoke.name
  dns_servers         = var.dns_servers
}

resource "azurerm_subnet" "pe_spoke" {
  name                                      = var.private_endpoint_spoke_name
  resource_group_name                       = azurerm_resource_group.pe_spoke.name
  virtual_network_name                      = azurerm_virtual_network.pe_spoke.name
  address_prefixes                          = var.pe_subnet
  private_endpoint_network_policies_enabled = var.private_link_service_network_policies_enabled
}


resource "azurerm_virtual_network_peering" "dc_pe_spoke" {
  name                      = "peer-${var.dc_name}-${var.private_endpoint_spoke_name}"
  resource_group_name       = azurerm_resource_group.dc.name
  virtual_network_name      = azurerm_virtual_network.dc.name
  remote_virtual_network_id = azurerm_virtual_network.pe_spoke.id
}

resource "azurerm_virtual_network_peering" "pe_spoke_dc" {
  name                      = "peer-${var.private_endpoint_spoke_name}-${var.dc_name}"
  resource_group_name       = azurerm_resource_group.pe_spoke.name
  virtual_network_name      = azurerm_virtual_network.pe_spoke.name
  remote_virtual_network_id = azurerm_virtual_network.dc.id
}

resource "azurerm_virtual_network_peering" "dc_vm_spoke" {
  name                      = "peer-${var.dc_name}-${var.vm_spoke_name}"
  resource_group_name       = azurerm_resource_group.dc.name
  virtual_network_name      = azurerm_virtual_network.dc.name
  remote_virtual_network_id = azurerm_virtual_network.vm_spoke.id
}

resource "azurerm_virtual_network_peering" "vm_spoke_dc" {
  name                      = "peer-${var.vm_spoke_name}-${var.dc_name}"
  resource_group_name       = azurerm_resource_group.vm_spoke.name
  virtual_network_name      = azurerm_virtual_network.vm_spoke.name
  remote_virtual_network_id = azurerm_virtual_network.dc.id
}

resource "azurerm_private_dns_zone" "dc" {
  name                = var.azurerm_private_dns_zone
  resource_group_name = azurerm_resource_group.dc.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dc" {
  name                  = var.dc_name
  resource_group_name   = azurerm_resource_group.dc.name
  private_dns_zone_name = azurerm_private_dns_zone.dc.name
  virtual_network_id    = azurerm_virtual_network.dc.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "pe_spoke" {
  name                  = var.private_endpoint_spoke_name
  resource_group_name   = azurerm_resource_group.dc.name
  private_dns_zone_name = azurerm_private_dns_zone.dc.name
  virtual_network_id    = azurerm_virtual_network.pe_spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "vm_spoke" {
  name                  = var.vm_spoke_name
  resource_group_name   = azurerm_resource_group.dc.name
  private_dns_zone_name = azurerm_private_dns_zone.dc.name
  virtual_network_id    = azurerm_virtual_network.vm_spoke.id
}

resource "azurerm_private_dns_a_record" "dc" {
  name                = azurerm_storage_account.pe_spoke.name
  zone_name           = azurerm_private_dns_zone.dc.name
  resource_group_name = azurerm_resource_group.dc.name
  records             = [azurerm_private_endpoint.pe_spoke.private_service_connection[0].private_ip_address]
  ttl                 = var.a_record_ttl
}
