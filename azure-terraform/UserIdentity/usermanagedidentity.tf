# ############################################################
# Azure user managed identity creation and assign acrpull role
# Created by - Aniket Mukherjee
# ############################################################

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "app-service-rg" {
  name = var.resource_group_name
}

data "azurerm_key_vault" "azure_key_vault" {
  name = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.app-service-rg.name
}


data "azurerm_container_registry" "registry" {
  name                = var.container_registry_name
  resource_group_name = data.azurerm_resource_group.app-service-rg.name
}

resource "azurerm_user_assigned_identity" "example" {
  resource_group_name = data.azurerm_resource_group.app-service-rg.name
  location            = data.azurerm_resource_group.app-service-rg.location

  name = "app-service-user-identity"
}

resource "azurerm_key_vault_access_policy" "key_vault_access" {
  key_vault_id = data.azurerm_key_vault.azure_key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.example.principal_id

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
  ]
  
  certificate_permissions = [
  "get",
  ]
}

resource "azurerm_role_assignment" "app_Service_identity_role" {
  scope                = data.azurerm_container_registry.registry.id
  role_definition_name = "acrPull"
  principal_id         = azurerm_user_assigned_identity.example.principal_id
}