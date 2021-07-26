Azure virtual machine creation
------------------------

This folder contains different VM creation scenarios using terraform.


Folder tree map
------------
```
├── README.md
├── create-multi-size-multi-vm-existing-vnet-rg
│   ├── backend.tfvars
│   ├── main.tf
│   ├── output.tf
│   ├── param.auto.tfvars
│   ├── param.nocommit
│   ├── provider.tf
│   └── variables.tf
├── create-rg-vnet-vm
│   ├── backend.tfvars
│   ├── main.tf
│   ├── output.tf
│   ├── param.auto.tfvars
│   ├── provider.tf
│   └── variables.tf
├── create-same-size-multi-vm-existing-vnet-rg
│   ├── backend.tfvars
│   ├── main.tf
│   ├── output.tf
│   ├── param.auto.tfvars
│   ├── param.nocommit
│   ├── provider.tf
│   └── variables.tf
└── create-vm-existing-vnet-rg
    ├── backend.tfvars
    ├── main.tf
    ├── output.tf
    ├── param.auto.tfvars
    ├── param.nocommit
    ├── provider.tf
    └── variables.tf
```

Pre-requisites
-------------
1. Azure resource group where VM will be created.
2. Azure vnet resource group while using existing vnet/subnet.



Github location 
----------------

All scripts are maintained within [Azure VM Repo](https://github.com/anikm1987/cloud_terraform/tree/master/azure-terraform/VM)



Getting Started
--------------

#### Configuration

1. Navigate to specified folder which you want to work with 

2. Update param.auto.tfvars according to your need (param.auto.tfvars is the file where you can define your own values, it overrides defaults values mentioned in variables.tf)-

3. Refer - variables.tf for detailed description of each variables. 

4. Make necessary changes in backend.tfvars file if you want to manage the tfstate file in Azure storage.
and uncomment line  #  backend "azurerm" {} in provider.tf file

5. Execute below commands for creating the app service -

```
# Dev
# if azure storage backend is enable in step 4
terraform init -backend-config="backend.tfvars"
terraform validate
terraform plan
terraform apply

# Note - Please keep note of the terraform outputs.

```

6. All VMs will be configured with SSH and disbled password authentication