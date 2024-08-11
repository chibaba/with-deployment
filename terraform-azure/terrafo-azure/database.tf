resource "azurecaf_name" "mysql_flexible_server" {
    name = var.name
    resource_type = "azurerm_mysql_server"
    suffixes = [var.environment_type, module.azure_region.location_short]
    random_length = 5
    clean_input = true
}

resource "azurecaf_name" "database" {
    name = var.name
    resource_type = "azurerm_mysql_database"
    suffixes = [var.environment_type, module.azure_region.location_short]
    clean_input = true
}
# Create an azurerm_private_dns_zone resource for the MySQL Flexible Server
resource "azurerm_private_dns_zone" "mysql_flexible_server" {
  name = "link-${azurerm_virtual_network.vnet.name}"
  private_dns_zone_name = azurerm_private_dns_zone.mysql_flexible_server.name
  virtual_network_id = azurerm_virtual_network.vnet.id
  resource_group_name = azurerm_resource_group.resource_group.name
  tags = var.default_tags
}
# Create a random_password resource for the MySQL Flexible Server administrator password
resource "random_password" "database_admin_password" {
    length = 16
    special = false
}
# Create an azurerm_mysql_flexible_server resource for the MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "mysql_flexible_server" {
  name = azurecaf_name.mysql_flexible_server.result
  resource_group_name = azurerm_resource_group.resource_group.name
  location = azurerm_resource_group.resource_group.location
  administrator_login = var.database_administrator_login
  administrator_password = random_password.database_admin_password.result
  backup_retention_days = var.database_backup_retention_days
  delegated_subnet_id = azurerm_subnet.vnet_subnets["${var.subnet_for_database}"].id
}