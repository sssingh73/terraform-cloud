variable "resource_group_name" {
  type        = string
  description = "This variable defines Resource group Name where app service plan and app services will be created"
}

variable "container_registry_name" {
  type        = string
  default     = "mydemoappregistry"
  description = "Azure Container Registry Name"
}

variable "key_vault_name" {
  type        = string
  default     = "mydemokv"
  description = "Azure Key vault name. Secrets will be read from here."
}