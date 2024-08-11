resource "azurecaf_name" "mysql_flexible_server" {
    name = var.name
    resource_type = "azurerm_mysql_server"
    suffixes = [var.environment_type, module.azure_region.location_short]
    random_length = 5
    clean_input = true
}