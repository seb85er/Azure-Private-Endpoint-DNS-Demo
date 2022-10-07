locals {
  password_command     = "$secureSafeModePassword=(ConvertTo-SecureString ${var.dsrm_password} -AsPlainText -Force)"
  install_ad_command   = "Install-WindowsFeature AD-Domain-Services -IncludeManagementTools"
  configure_ad_command = "Install-ADDSForest -DomainMode 'Win2012R2' -DomainName ${var.domain_name}  -DomainNetbiosName ${var.netbios_name} -ForestMode 'Win2012R2' -InstallDns:$true -NoRebootOnCompletion:$true -SafeModeAdministratorPassword $secureSafeModePassword -Force:$true"
  forwarder_command    = "Add-DnsServerConditionalForwarderZone -Name 'blob.core.windows.net' -MasterServers 168.63.129.16 -PassThru"
  shutdown_command     = "Restart-Computer -Force"
  exit_code_hack       = "exit 0"
  powershell_command   = " ${local.password_command}; ${local.install_ad_command}; ${local.configure_ad_command}; ${local.forwarder_command}; ${local.shutdown_command}; ${local.exit_code_hack}"
}

