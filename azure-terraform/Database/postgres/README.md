Azure postgres database creation
-----------------------------------------
This terraform code is to create postgres database server (PAAS) inside the resource group in azure. Terraform state will be managed in remote azure storage backend.

Pre-requisites
-------------
1. Azure Resource group where it will be created.
2. Azure storage account with a container 
3. Terraform >= 0.13


Configuration
------------
1. Update main_dev.tfvars according to your need (main_dev.tfvars is the file where you can define your own values, it overrides defaults values mentioned in variables.tf. We normally change only this file with exact values required as per the project.)-
```
resource_group_name       = "Postgres-RG-Dev"
database_name             = "testdb"
administrator_login       = "admin"
set_firwall_rule          = true
app_name                  = "api"
business_unit_group       = "rd"
environment               = "dev"
owner                     = "Aniket Mukherjee"
description               = "Postgres development instance"
rule_name_list            = ["vpn1","vpn2"]
ip_address_list           = ["10.28.90.1","10.25.90.1"]

```
2. Refer - variables.tf for detailed description of each variables. Also if you want to overwrite any of the default values mentioned in the variables.tf then you can copy that variable into main_dev.tfvars and provide your own value.

3. If you do not wish to set firewall during creation of database server then you can disable it by making the set_firwall_rule=false in main_dev.tfvars 

4.   Above mentioned tfvars will create 
```
    Azure database service with name - rd-api-eastus2-dev-database-service 
    and Database name - testdb-dev
```
5. Execute below commands for creating the database service -

```
# Dev
terraform init -backend-config="backend_dev.tfvars"
terraform validate
terraform plan -var-file=main_dev.tfvars
terraform apply -var-file=main_dev.tfvars

# Note - Please keep note of the terraform output (postgres_database_admin_password) of database admin password
         in your keepass. 

```

6. Quick test of database connectivity using python

```
cd /Database/postgres/scripts
pip install -r requirements.txt # if psycopg2 package is not installed

# Check below parameters in check_pg_connectivity_create_user.py file

    database_name = "testdb-dev"
    database_server_name="rd-api-eastus2-dev-database-service"
    database_server_fqdn = "rd-api-eastus2-dev-database-service.postgres.database.azure.com"
    database_admin="admin"

python check_pg_connectivity_create_user.py

# if you want to create nonsuperuser in your database then make sure that create_user_flag=True.
# By default the option is create_user_flag=False
```