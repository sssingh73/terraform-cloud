##########################################################
# Azure Postgres Database Service Creation 
# Initial draft prepared by - Aniket Mukherjee
##########################################################

# Get a resource group
data "azurerm_resource_group" "database-service-rg" {
  name = var.resource_group_name
}

# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}

# https://www.terraform.io/docs/providers/azurerm/r/postgresql_server.html
resource "azurerm_postgresql_server" "postgres-database-server" {
  name                             = "${var.business_unit_group}-${var.app_name}-${data.azurerm_resource_group.database-service-rg.location}-${var.environment}-database-service"
  location                         = data.azurerm_resource_group.database-service-rg.location
  resource_group_name              = data.azurerm_resource_group.database-service-rg.name

  storage_mb                       = var.database_storage
  backup_retention_days            = 7
  geo_redundant_backup_enabled     = false
  auto_grow_enabled                = true

  administrator_login              = var.administrator_login
  administrator_login_password     = random_password.password.result
  sku_name                         = var.sku_name
  version                          = var.database_version
  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = var.ssl_minimal_tls_version_enforced
  
  tags = {
    Description = var.description
    Environment = var.environment
    Owner       = var.owner
    BusinessUnit = var.business_unit_group
  }
}


# https://www.terraform.io/docs/providers/azurerm/r/postgresql_database.html
resource "azurerm_postgresql_database" "postgres-database" {
  name                    = "${var.database_name}-${var.environment}"
  resource_group_name     = data.azurerm_resource_group.database-service-rg.name
  server_name             = azurerm_postgresql_server.postgres-database-server.name
  charset                 = "utf8"
  collation               = "English_United States.1252"
}



# https://www.terraform.io/docs/providers/azurerm/r/postgresql_firewall_rule.html
resource "azurerm_postgresql_firewall_rule" "postgres-firewall-allow-access" {
   name                   = "allow_access_azure_services"
   resource_group_name    = data.azurerm_resource_group.database-service-rg.name
   server_name            = azurerm_postgresql_server.postgres-database-server.name
   start_ip_address       = "0.0.0.0"
   end_ip_address         = "0.0.0.0"
 }

# list to add 
module "firewall_rule_list" {
  count                   = var.set_firwall_rule ? 1 : 0
  source                  = "./modules/firewall_list"
  rule_name_list          = var.rule_name_list
  postgres_server_name    = azurerm_postgresql_server.postgres-database-server.name
  resource_group_name     = data.azurerm_resource_group.database-service-rg.name
  ip_address_list         = var.ip_address_list
  
}

output "postgres_database_fqdn" {
  value       = "https://${azurerm_postgresql_server.postgres-database-server.fqdn}"
  description = "The postgres databse server full qualified domain name"
}

output "postgres_database_admin" {
  value       = azurerm_postgresql_server.postgres-database-server.administrator_login
  description = "The postgres databse server admin user"
}

output "postgres_database_admin_password" {
  value       = azurerm_postgresql_server.postgres-database-server.administrator_login_password
  description = "The postgres databse server admin credential"
}

output "postgressql_db_name" {
  value       = azurerm_postgresql_database.postgres-database.name
  description = "The postgres database name"
}
