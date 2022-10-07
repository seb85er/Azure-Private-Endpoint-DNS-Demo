variable "location" {
  type        = string
  description = "location to deploy resources"
  default     = "west europe"
}

variable "dc_name" {
  type        = string
  description = "dc resource name"
  default     = "dc"
}

variable "private_endpoint_spoke_name" {
  type        = string
  description = "private endpoint resource name"
  default     = "pe-spoke"
}

variable "vm_spoke_name" {
  type        = string
  description = "virtual machine resource name"
  default     = "workload-spoke"
}

variable "management_ip" {
  type        = string
  description = "Source IP that will rdp to server"
}

variable "dsrm_password" {
  type        = string
  description = "password for active directory dsrm"
}

variable "domain_name" {
  type        = string
  description = "active directory full domain"
  default     = "azure-labs.cloud"
}

variable "netbios_name" {
  type        = string
  description = "active directory netbios name"
  default     = "azure-labs"
}


variable "dc_address_space" {
  default = ["10.0.0.0/16"]
}

variable "dc_subnet" {
  default = ["10.0.1.0/24"]
}

variable "dns_servers" {
  default = ["10.0.1.4"]
}

variable "private_link_service_network_policies_enabled" {
  default = true
}


variable "vm_address_space" {
  default = ["10.1.0.0/16"]
}

variable "vm_subnet" {
  default = ["10.1.1.0/24"]
}

variable "pe_address_space" {
  default = ["10.2.0.0/16"]
}

variable "pe_subnet" {
  default = ["10.2.1.0/24"]
}

variable "storage_account_name" {
  default = "strprivlab"
}

variable "enable_custom_domain" {
  default = false
}

variable "custom_domain_name" {
  default = null
}

variable "azurerm_private_dns_zone" {
  default = "privatelink.blob.core.windows.net"
}

variable "stracc_account_tier" {
  default = "Standard"
}

variable "stracc_account_replication_type" {
  default = "LRS"
}

variable "stracc_account_container" {
  default = "content"
}

variable "stracc_account_container_type" {
  default = "private"
}

variable "pe_subresource_names" {
  default = ["blob"]
}

variable "test_file_name" {
  default = "testfile.txt"
}

variable "blob_storage_type" {
  default = "Block"
}

variable "pip_sku" {
  default = "Standard"
}

variable "pip_allocation_method" {
  default = "Static"
}

variable "vm_size" {
  default = "Standard_B2ms"
}

variable "admin_username" {
  default = "adminuser"
}

variable "os_disk_caching" {
  default = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  default = "Standard_LRS"
}


variable "source_image_reference_publisher" {
  default = "MicrosoftWindowsServer"
}

variable "source_image_reference_offer" {
  default = "WindowsServer"
}

variable "source_image_reference_sku" {
  default = "2022-Datacenter"
}

variable "source_image_reference_version" {
  default = "latest"
}

variable "vm_ext_name" {
  default = "vm-setup"
}

variable "vm_ext_publisher" {
  default = "Microsoft.Compute"
}

variable "vm_ext_type" {
  default = "CustomScriptExtension"
}

variable "vm_ext_type_handler_version" {
  default = "1.9"
}

variable "private_ip_address_allocation" {
  default = "Dynamic"
}

variable "a_record_ttl" {
  default = 300
}
