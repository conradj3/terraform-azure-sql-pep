# Generate Random String for SQL Resource.
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

# Retrieve Azure Resource Group information.
data "azurerm_resource_group" "rg" {
  name = var.azure_resource_group_name
}

# Reteive Azure Virtual Network information.
data "azurerm_virtual_network" "network" {
  name                = var.azure_virtual_network_name
  resource_group_name = var.azure_virtual_network_resourcegroup
}

# Retrieve Azure Virtual Network Subnet information.
data "azurerm_subnet" "subnet" {
  name                 = var.azure_virtual_subnet_name
  virtual_network_name = data.azurerm_virtual_network.network.name
  resource_group_name  = data.azurerm_virtual_network.network.resource_group_name
}

# Create Azure Storage Account for MSSQL
resource "azurerm_storage_account" "storage" {
  name                     = format("%smssqlstorageacct", random_string.random.result)
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = coalesce(var.azure_location, data.azurerm_resource_group.rg.location)
  account_tier             = var.azure_storage_account_tier
  account_replication_type = var.azure_storage_account_replication_type
  min_tls_version          = var.azure_storage_min_tls_version
  tags                     = var.azure_tags
}

# Create Azure MSSQL resource.
resource "azurerm_mssql_server" "mssql" {
  name                         = format("%s-mssql", random_string.random.result)
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = coalesce(var.azure_location, data.azurerm_resource_group.rg.location)
  version                      = var.azure_sql_version
  administrator_login          = var.azure_sql_administrator_login
  administrator_login_password = var.azure_sql_administrator_password
  minimum_tls_version          = var.azure_sql_min_tls_version
  tags                         = var.azure_tags
}

# Create Azure MSSQL Auditing Policy
resource "azurerm_mssql_server_extended_auditing_policy" "mssqlaudit" {
  server_id                               = azurerm_mssql_server.mssql.id
  storage_endpoint                        = azurerm_storage_account.storage.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.storage.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 7
}

# Create Azure Private Endpoint with Private Connection to MySQL resource.
resource "azurerm_private_endpoint" "pep" {
  count               = var.enable_private_endpoint == true ? 1 : 0
  name                = format("%s-pep", random_string.random.result)
  location            = coalesce(var.azure_location, data.azurerm_resource_group.rg.location)
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.subnet.id

  private_service_connection {
    name                           = format("%s-psc", random_string.random.result)
    private_connection_resource_id = azurerm_mssql_server.mssql.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
  tags = var.azure_tags
}
