variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the PostgreSQL Server will be created"
}

variable "database_version" {
  type        = string
  description = "This variable specifies the version of PostgreSQL to use. Valid values are 9.5, 9.6, 10, 10.0, and 11."
  default     = "11"
}

variable "sku_name" {
  type        = string
  description = "Specifies the SKU Name for this PostgreSQL Server. The name of the SKU, follows the tier + family + cores pattern (e.g. B_Gen4_1, GP_Gen5_8)"
  default     = "GP_Gen5_4"
}

variable "database_name" {
  type        = string
  description = "This variable defines database Name."
}

variable "administrator_login" {
  type        = string
  description = "This variable defines Administrator Name for the database server which will be created"
}

variable "ssl_minimal_tls_version_enforced" {
  type        = string
  description = "SSL minimum tls version - recommended TLS1_2"
  default     = "TLS1_2"
}

variable "database_storage" {
  type        = string
  description = "PostgreSQL Storage in MB"
  default     = "5120"
}


variable "set_firwall_rule" {
  type        = bool
  description = "Boolean indicator to determine if firewall rules to be set."
  default     = false
}

variable "rule_name_list" {
  type        = list
  description = "list of rule name mapping to ip_address_list to describe what we're allowing"
  default     = ["testServer"]
}

variable "ip_address_list" {
  type        = list
  description = "list of single IP addresses to whitelist for access"
  default     = ["10.0.0.1"]
}

variable "app_name" {
  type        = string
  description = "This variable defines the application name,  use to build database server name"
}

variable "business_unit_group" {
  type        = string
  description = "This variable defines the business unit group, used to build resources"
}

variable "environment" {
  type        = string
  description = "This variable defines the environment to be built,  used to build resources"
}

variable "business_owner" {
  type        = string
  description = "Specify the business owner of the resource , used in tag"
}

variable "description" {
  type        = string
  description = "Provide a description of the resource, used in tag"
}

