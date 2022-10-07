output "spoke_pip" {
  value = azurerm_public_ip.vm_spoke.ip_address
}

output "dc_pip" {
  value = azurerm_public_ip.dc.ip_address
}

output "vm_pwd_spoke" {
  value     = random_password.vm_spoke.result
  sensitive = true
}

output "vm_pwd_dc" {
  value     = random_password.dc.result
  sensitive = true
}

output "sas_url_query_string" {
  value     = data.azurerm_storage_account_sas.pe_spoke.sas
  sensitive = true
}