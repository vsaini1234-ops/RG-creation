resource "azurerm_resource_group" "RG-test" {
  for_each = var.rgs
  name     = each.value.name
  location = each.value.location
}