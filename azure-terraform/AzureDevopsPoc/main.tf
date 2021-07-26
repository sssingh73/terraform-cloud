# Make sure to set the following environment variables:
#   AZDO_PERSONAL_ACCESS_TOKEN
#   AZDO_ORG_SERVICE_URL
provider "azuredevops" {
  version = ">= 0.0.1"
}

resource "azuredevops_project" "project" {
  project_name = "test-aniket-test-tf"
  description  = "Devops pipeline to ADO TF"
}


// This section configures an Azure DevOps Variable Group
resource "azuredevops_variable_group" "test-tf-provider" {
  project_id   = azuredevops_project.project.id
  name         = "test-tf-provider"
  description  = "Azure TF providers"
  allow_access = true

  variable {
    name      = "ARM_CLIENT_ID"
    value     = "05-xxxxxxxxxxxxxxxx-xxxxxxxxxxxxxxxxx"
    is_secret = true
  }
  variable {
    name      = "ARM_CLIENT_SECRET"
    value     = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    is_secret = true
  }
  variable {
    name = "ARM_TENANT_ID"
    value = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  }
  variable {
    name      = "ARM_ACCESS_KEY"
    value     = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    is_secret = true
  }
  
}

// This section configures an Azure DevOps Variable Group
resource "azuredevops_variable_group" "test-tf-backend" {
  project_id   = azuredevops_project.project.id
  name         = "test-tf-backend"
  description  = "Variable to keep all details about tfstate storage"
  allow_access = true

  variable {
    name      = "storage_account_name"
    value     = "testxyghtfstorage"
    is_secret = true
  }
  variable {
    name      = "key"
    value     = "terraform.tfstate"
    is_secret = true
  }
  variable {
    name = "container_name"
    value = "tfstate"
    is_secret = true
  }
  variable {
    name      = "resource_group_name"
    value     = "demo-test-rg"
    is_secret = true
  }
}

resource "azuredevops_user_entitlement" "user" {
  principal_name = "abc@test.com"
}

data "azuredevops_group" "group" {
  project_id = azuredevops_project.project.id
  name       = "Build Administrators"
}

resource "azuredevops_group_membership" "membership" {
  group = data.azuredevops_group.group.descriptor
  members = [
    azuredevops_user_entitlement.user.descriptor
  ]
}
