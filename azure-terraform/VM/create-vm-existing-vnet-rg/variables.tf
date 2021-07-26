variable "resource_group_name" {
  type        = string
  description = "This variable defines Resource group Name where vm will be created"
}

variable "vnet_resource_group_name" {
  type        = string
  description = "This variable defines Resource group Name where vnet and subnets are deployed"
}

variable "business_unit_group" {
  type        = string
  description = "This variable defines the business unit group, used to build resources"
}

variable "environment" {
  type        = string
  description = "This variable defines the environment to be built,  used to build resources"
}

variable "region" {
  type        = string
  description = "Azure region where the resource group will be created,  used to build resources"
  default     = "eastus2"
}

variable "description" {
  type        = string
  description = "Provide a description of the resource, used in tag"
}

variable "vnet_name" {
  type        = string
  description = "Name of the Azure virtual network"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet to be associated with vnet"
}


variable "admin_ssh_user_name" {
  type        = string
  default     = "azureuser"
  description = "Admin user for the VM "
}


variable "vm_size" {
  type        = string
  default     = "Standard_DS1_v2"
  description = "Azure vm size "
}
