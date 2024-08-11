resource "azurecaf_name" "admin_vm" {
  name = var.name
  resource_type = "azurerm_linux_virtual_machine"
  suffixes = ["admin", var.environment_type, module.azure_region.location_short]
  clean_input = true
}

resource "azurecaf_name" "admin_vm_nic" {
    name = var.name
    resource_type = "azurerm_network_interface"
    suffixes = ["admin", var.environment_type, module.azure_region.location_short]
    clean_input = true
}
# Create the network interface for the admin VM
resource "azurerm_network_interface" "admin_vm" {
    name = azurecaf_name.admin_vm_nic.result
    resource_group_name = azurerm_resource_group.resource_group.name
    location = azurerm_resource_group.resource_group.location
    tags = var.default_tags

    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.vnet_subnets["${var.subnet_for_vms}"].id
      private_ip_address_allocation = "Dynamic"
    }
  
}

# Random password for Wordpress admin account
