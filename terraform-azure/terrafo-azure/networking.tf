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