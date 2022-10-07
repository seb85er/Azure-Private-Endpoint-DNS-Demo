data "azurerm_storage_account_sas" "pe_spoke" {
  connection_string = azurerm_storage_account.pe_spoke.primary_connection_string

  resource_types {
    service   = true
    container = true
    object    = true
  }

  start  = timestamp()
  expiry = timeadd(timestamp(), "720h")

  services {
    blob  = true
    queue = false
    table = false
    file  = true
  }

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = true
    add     = true
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}


