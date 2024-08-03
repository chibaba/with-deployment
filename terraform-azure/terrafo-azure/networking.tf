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
resource "azurerm_subnet" "vnet_subnets" {
      # Iterate over the vnet_subnets variable
for_each = var.vnet_subnets
name = azurecaf_name.virtual_network_subnets[each.key].result
resource_group_name = azurerm_resource_group.resource_group.name
virtual_network_name = azurerm_resource_group.vnet.name
address_prefixes = [each.value.address_prefix]
    # Use the service endpoints from the vnet_subnets variable if they are provided, otherwise use an empty list
service_endpoints = try(each.value.service_endpoints, [])
# Use the private endpoint network policies enabled value from the vnet_subnets variable if it is provided, otherwise use an empty list
private_endpoint_network_policies_enabled = try(each.value.private_endpoint_network_policies_enabled, [])
  # Iterate over the service delegations in the vnet_subnets variable
dynamic "delegation" {
    for_each = each.value.service_delegations
    content {
            # Use the service delegation key as the name
       name = delegation.key
             # Iterate over the service delegation values
       dynamic "service_delegation" {
         for_each = delegation.value
         iterator = item
         content {
            # Use the service delegation value key as the name
          name = item.key
          # Use the service delegation value as the actions
          actions = item.value
         }
       }
    }
  
}
}
# Create an azurerm_public_ip resource, which represents a public IP address in Azure which will be used for the load balancer
resource "azurerm_public_ip" "load_balancer" {
  name = azurecaf_name.load_balancer_pip.result
  resource_group_name = azurerm_resource_group.resource_group.name
  location = azurerm_resource_group.resource_group.location
  sku = "standard"
  allocation_method = "static"
  tags = var.default_tags
}

# Create an azurerm_lb resource, which represents an Azure load balancer
resource "azurerm_lb" "load_balancer" {
  name = azurecaf_name.load_balancer.result
  resource_group_name = azurerm_resource_group.resource_group.name
  location = azurerm_resource_group.resource_group.location
  sku = "standard"
  tags = var.default_tags


# Create a frontend IP configuration using the public IP address from the azurerm_public_ip resource
frontend_ip_configuration {
    name = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip_address.load_balancer.id

}
}

# Create an azurerm_lb_backend_address_pool resource, which represents a backend address pool for an Azure load balancer
resource "azurerm_lb_backend_address_pool" "load_balancer" {
    # Use the ID of the azurerm_lb resource as the load balancer ID
loadbalancer_id = azurerm_lb.load_balancer.id
name = "BackendAddressPool"
}