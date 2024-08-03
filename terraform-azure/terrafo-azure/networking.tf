resource "azurecaf_name" "vnet" {
    name  = var.name
    resource_type = "azurerm_virtual_network"
    suffixes = [var.environment_type, module.azure_region.location_short]
    clean_input = true
}

resource "azurecaf_name" "virtual_network_subnets" {
    for_each = var.vnet_subnets
    # Set the name variable to the subnet_name value in the current iteration of the for_each loop
    name = each.value.subnet_name
    resource_type = "azurem_subnet"
    suffixes = [var.name, var.environment_type, module.azure_region.location_short]
    clean_input = true
}

resource "azurecaf_name" "load_balancer" {
    name = var.name
    resource_type = "azurerm_lb"
    suffixes = [var.environment_type, module.azure_region.location_short]
    clean_input = true  
}

resource "azurecaf_name" "load_balancer_pip" { 
    name = azurecaf_name.load_balancer.result
    resource_type = "azurerm_public_ip"
    clean_input = true
}

resource "azurecaf_name" "nsg" {
    name = var.name
    resource_type = "azurerm_network_security_group"
    suffixes = [var.environment_type, module.azure_region.location_short]
    clean_input = true
}
# This block of code creates a resource of type "azurerm_virtual_network" and assigns it to the variable "vnet"
resource "azurerm_virtual_network" "vnet" {
  resource_group_name = azurerm_resource_group.resource_group.name
  location = azurerm_resource_group.resource_group.location
  name = azurecaf_name.vnet.result
  address_space = var.vnet_address_space
  tags = var.default_tags
}

# Create an azurerm_subnet resource for each subnet in the virtual network using the vnet_subnets variable
resource "" "name" {
  
}