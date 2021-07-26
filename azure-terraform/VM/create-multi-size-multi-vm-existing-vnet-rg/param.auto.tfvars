resource_group_name       = "vm-demo-rg"
vnet_resource_group_name  = "vnet_demo_rg"
business_unit_group       = "rnd"
environment               = "dev"
description               = "VM instance"
region                    = "eastus2"
vnet_name                 = "myVnet"
subnet_name               = "mySubnet"
admin_ssh_user_name       = "azureuser"
vm_size                   = {
                                vm1 = "Standard_DS1_v2"
                                vm2 = "Standard_ES2_v2"
                            }