Azure App Service with Docker container
-----------------------
This terraform code is to create Azure app service with custom docker container inside the resource group in azure. Terraform state will be managed in remote azure storage backend.

Feature List - 
-------------
1. Create app service within app service plan using IaC terraform.
    - This will deploy and run mydemoappregistry.azurecr.io/blogger/mydemoapp:v1.0.0 docker image.
2. Expose postgres database connection string using application settings.
3. Secure integration with Azure Key-vault, password read from key-vault at the runtime.
4. Enable system assigned identity to access Azure container registry securely with only AcrPull role.


Pre-requisites
-------------
1. Azure Resource group where it will be created.
2. Azure storage account with a container 
3. Azure container registry with the docker image stored inside of it.
4. Azure key vault with password updated.
5. Terraform >= 0.13


Github location 
----------------

All scripts are maintained within [Azure App Service Repo](https://github.com/anikm1987/cloud_terraform/tree/master/azure-terraform/AppService)


Getting Started
--------------

#### Configuration

1. Update param.tfvars  according to your need (param.tfvars is the file where you can define your own values, it overrides defaults values mentioned in variables.tf)-
```
resource_group_name       = "app-service-demo-rg"
app_service_plan_name     = "mydemoapp-service-plan"
business_unit_group       = "rnd"
environment               = "dev"
description               = "App Service instance"
region                    = "eastus2"
app_name                  = "mydemoapp"
cors_allowed_origins      = ["http://localhost:8080"]
container_registry_name   = "mydemoappregistry"
container_image           = "blogger/mydemoapp"
IMAGE_TAG                 = "v1.0.0"
key_vault_name            = "mydemokv"

```
2. Refer - variables.tf for detailed description of each variables. 

3. Update below app_settings section in main.tf file according to your need for aditional parameters -

```
app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE   = false
    DOCKER_REGISTRY_SERVER_URL            = "https://${data.azurerm_container_registry.registry.login_server}"
    DB_DRIVER                             = "org.postgresql.Driver"
    DB_URL                                = "jdbc:postgresql://mydemodbservice.postgres.database.azure.com:5432/mydemodatabase?sslmode=require"
    DB_USERNAME                           = "mydemouser@mydemodbservice"
    DB_PASSWORD                           = "@Microsoft.KeyVault(SecretUri=https://mydemokv.vault.azure.net/secrets/DB-USER-PASSWORD/23412434asd873487274472342e375d7c)"
  }


Note: mydemoapp application has dependency on - DB_DRIVER, DB_URL, DB_USERNAME and DB_PASSWORD. You can add/remove according to your application need.

```

4. Make necessary changes in backend.tfvars file 

```
resource_group_name  = "app-service-demo-rg"
storage_account_name = "appservicestorage"
container_name       = "tfstate"
key                  = "appservice.terraform.tfstate"
```

5. Execute below commands for creating the app service -

```
# Dev
terraform init -backend-config="backend.tfvars"
terraform validate
terraform plan -var-file=param.tfvars
terraform apply -var-file=param.tfvars

# Note - Please keep note of the terraform output.

```

6. This will create Azure app Service with pattern (${var.app_name}-${resource_group_location}-${var.environment}--app-service)    
```
Above mentioned tfvars will create 
Azure app service with name - mydemoapp-eastus2-dev--app-service 
Connection with 
    database name - mydemodatabase, 
    key vault name - mydemokv and 
    acr registry - mydemoappregistry
```
