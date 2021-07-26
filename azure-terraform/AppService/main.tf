##########################################################
# Azure App Service Creation- Initial draft prepared by - Aniket Mukherjee
# This will create containerized app service inside your ASE environment based on existing App service plan.
# This terraform file create secure connection with registry and Keyvault
##########################################################

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "app-service-rg" {
  name = var.resource_group_name
}

data "azurerm_user_assigned_identity" "user-assigned-identity" {
  name                = var.user_identity_name
  resource_group_name = data.azurerm_resource_group.appservice-rg.name
}

data "azurerm_key_vault" "azure_key_vault" {
  name = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.app-service-rg.name
}

data "azurerm_app_service_plan" "app-service-plan" {
  name                = var.app_service_plan_name
  resource_group_name = data.azurerm_resource_group.app-service-rg.name
}

data "azurerm_container_registry" "registry" {
  name                = var.container_registry_name
  resource_group_name = data.azurerm_resource_group.app-service-rg.name
}

# Create the App Service
resource "azurerm_app_service" "app-service" {
  name                = "${var.app_name}-${var.region}-${var.environment}-app-service"
  location            = data.azurerm_resource_group.app-service-rg.location
  resource_group_name = data.azurerm_resource_group.app-service-rg.name
  app_service_plan_id = data.azurerm_app_service_plan.app-service-plan.id
  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE   = false
    DOCKER_REGISTRY_SERVER_URL            = "https://${data.azurerm_container_registry.registry.login_server}"
    DB_DRIVER                             = "org.postgresql.Driver"
    DB_URL                                = "jdbc:postgresql://mydemodbservice.postgres.database.azure.com:5432/mydemodatabase?sslmode=require"
    DB_USERNAME                           = "mydemouser@mydemodbservice"
    DB_PASSWORD                           = "@Microsoft.KeyVault(SecretUri=https://mydemokv.vault.azure.net/secrets/DB-USER-PASSWORD/23412434asd873487274472342e375d7c)"
  }
  
  https_only = true
  site_config {
    linux_fx_version = "DOCKER|${data.azurerm_container_registry.registry.login_server}/${var.container_image}:${var.IMAGE_TAG}"
    always_on        = true
    cors {
      allowed_origins     = var.cors_allowed_origins
      support_credentials = false
      }
  }
  
  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids=[data.azurerm_user_assigned_identity.user-assigned-identity.id]
  }
 
  tags = {
    Description = var.description
    Environment = var.environment
    BusinessUnit = var.business_unit_group
  }
}


resource "azurerm_key_vault_access_policy" "key_vault_access" {
  key_vault_id = data.azurerm_key_vault.azure_key_vault.id
  tenant_id    = data.azurerm_client_config.identity.0.tenant_id
  object_id    = azurerm_app_service.app-service.identity.0.principal_id

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

# output the app service plan and app service url
output "appservice_plan" {
  value       = data.azurerm_app_service_plan.app-service-plan.name
  description = "The App Service Plan"
}

# output the app service plan and app service url
output "appservice_name" {
  value       = azurerm_app_service.app-service.name
  description = "The App Service Name"
}

output "website_hostname" {
  value       = "https://${azurerm_app_service.app-service.default_site_hostname}"
  description = "The hostname of the website"
}
