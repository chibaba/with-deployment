# Create an azurecaf_name resource, which generates a unique name for an Azure resource of a specified type
resource "azurecaf_name" "resource_group" {
    name  = var.name
    resource_type = "azurerm_resource_group"
    suffixes = [var.environment_type, mdule.azure_region.location_short]
    clean_input = true
}

# Create an azurerm_resource_group resource, which represents an Azure resource group
