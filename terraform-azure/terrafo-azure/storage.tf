# Create the azurecaf_name resources, which generates a unique name for an Azure resource of a specified type
resource "azurecaf_name" "sa" {
  name = var.name
  resource_type = "azurerm_storage_account"
  suffixes = [var.environment_type, module.azure_region.location_short]
  random_length = 5
  clean_input = true
}

resource "azurecaf_name" "sa_endpoint" {
    name = azurecaf_name.sa.result
    resource_type = "azurerm_private_endpoint"
    clean_input = true
  
}
# This block of code creates a resource of type "azurerm_storage_account", which represents an Azure Storage Account
resource "azurerm_storage_account" "sa" {
  resource_group_name = azurerm_resource_group.resource_group.name
  location = azurerm_resource_group.resource_group.location
  access_tier = var.sa_account_tier
  account_kind = var.sa.account_kind
  account_replication_type = var.sa.account_replication_type
  enable_https_traffic_only = va.sa.enable_https_traffic_only
  min_tls_version = var.sa.min_tls_version
  tags = var.default_tags
}

# This block of code creates a resource of type "azurerm_storage_account_network_rules", which represents the network rules for an Azure Storage Account using the IP address of the current machine
