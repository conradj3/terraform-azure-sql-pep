variable "azure_resource_group_name" {
  description = "Use this variable to create new Azure resource group."
}
variable "azure_location" {
  description = "Set your default location, default to Azure eastus2."
  default     = null
}
variable "azure_virtual_network_name" {
  description = "Set Azure Virtual Nework name."
}
variable "azure_virtual_network_resourcegroup" {
  description = "Set Azure Virtual Nework resource group name."
}
variable "azure_virtual_subnet_name" {
  description = "Set Azure Subnet name."
}
variable "azure_storage_account_tier" {
  description = "Sets the default account tier for the Azure Storage Account."
  default     = "Standard"
  validation {
    condition     = var.azure_storage_account_tier == "Standard" || var.azure_storage_account_tier == "Premium"
    error_message = "This module only allows for Standard / Premium tier."
  }
}
variable "azure_storage_account_replication_type" {
  description = "Sets the default accountt tier for the Azure Storage Account."
  default     = "LRS"
  validation {
    condition     = var.azure_storage_account_replication_type == "LRS" || var.azure_storage_account_replication_type == "GRS"
    error_message = "This module only allows for LRS or GRS."
  }
}
variable "azure_storage_min_tls_version" {
  description = "Sets minimum TLS version for Storage and SQL resource."
  default     = "TLS1_2"
}
variable "azure_sql_administrator_login" {
  description = "Sets default login account for SQL resource."
  default     = "mssqladmin"
}
variable "azure_sql_administrator_password" {
  description = "Sets default password for SQL admin account."
  default     = "Ch@ng3m3!"
}
variable "azure_sql_version" {
  description = "Sets default password for SQL admin account."
  default     = "12.0"
  validation {
    condition     = var.azure_sql_version == "12.0" || var.azure_sql_version == "2.0"
    error_message = "Validate values are 12.0 for SQL v12 or 2.0 for SQL v11."
  }
}
variable "azure_sql_min_tls_version" {
  description = "Sets minimum TLS version for Storage and SQL resource."
  default     = "1.2"
}
variable "enable_private_endpoint" {
  description = "Enables SQL resource with private endpoint."
  type        = bool
  default     = true
}
variable "azure_tags" {
  description = "Set Azure default tags for all resources created by Terraform Azure Sql module."
  type        = map(any)
  default = {
    "Owner"     = "Database Technologies"
    "CreatedBy" = "Terraform"
  }
}
