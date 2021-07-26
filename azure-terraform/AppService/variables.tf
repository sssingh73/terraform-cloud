variable "resource_group_name" {
  type        = string
  description = "This variable defines Resource group Name where app service plan and app services will be created"
}

variable "app_service_plan_name" {
  type        = string
  description = "This variable defines App Service plan Name using which app services will be created"
}

variable "business_unit_group" {
  type        = string
  description = "This variable defines the business unit group, used to build resources"
}

variable "app_name" {
  type        = string
  description = "This variable defines the application name,  used to build resources"
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

variable "container_registry_name" {
  type        = string
  default     = "mydemoappregistry"
  description = "Azure Container Registry Name"
}

variable "container_image" {
  type        = string
  default     = "blogger/mydemoapp"
  description = "Container image name. Example: `blogger/mydemoapp`."
}

variable "IMAGE_TAG" {
  type        = string
  default     = "v1.0.0"
  description = "Container image name. "
}

variable "cors_allowed_origins" {
  type        = list
  description = "List of IPs/FQDN to add to allowed origins whitelist"
  default = ["*"]
}

variable "key_vault_name" {
  type        = string
  default     = "mydemokv"
  description = "Azure Key vault name. Secrets will be read from here."
}

variable "user_identity_name" {
  type        = string
  default     = "app-service-user-identity"
  description = "Azure user managed identity name which has acrPull role assigned."
}