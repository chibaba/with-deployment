resource "azurecaf_name" "admin_vm" {
  name = var.name
  resource_type = "azurerm_linux_virtual_machine"
  suffixes = ["admin", var.environment_type, module.azure_region.location_short]
  clean_input = true
}