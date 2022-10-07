resource "azurerm_storage_account" "pe_spoke" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.pe_spoke.name
  location                 = azurerm_resource_group.pe_spoke.location
  account_tier             = var.stracc_account_tier
  account_replication_type = var.stracc_account_replication_type
   dynamic custom_domain {
    for_each = var.enable_custom_domain == true ? [1] : []
    content {
      name =  "${var.storage_account_name}.${var.custom_domain_name}"
    }
  }
}

resource "azurerm_storage_container" "pe_spoke" {
  name                  = var.stracc_account_container
  storage_account_name  = azurerm_storage_account.pe_spoke.name
  container_access_type = var.stracc_account_container_type
}

resource "azurerm_storage_blob" "pe_spoke" {
  name                   = var.test_file_name
  storage_account_name   = azurerm_storage_account.pe_spoke.name
  storage_container_name = azurerm_storage_container.pe_spoke.name
  type                   = var.blob_storage_type
  source                 = var.test_file_name
}

resource "azurerm_private_endpoint" "pe_spoke" {
  name                = "pe-${var.private_endpoint_spoke_name}"
  location            = azurerm_resource_group.pe_spoke.location
  resource_group_name = azurerm_resource_group.pe_spoke.name
  subnet_id           = azurerm_subnet.pe_spoke.id

  private_service_connection {
    name                           = "psc-${var.private_endpoint_spoke_name}"
    private_connection_resource_id = azurerm_storage_account.pe_spoke.id
    is_manual_connection           = false
    subresource_names              = var.pe_subresource_names
  }
}
