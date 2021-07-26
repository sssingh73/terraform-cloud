variable "rule_name_list" {
  type        = list
  description = "list of rule name mapping to ip_address_list to describe what we're allowing"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the PostgreSQL Server exist"
}

variable "postgres_server_name" {
  type        = string
  description = "Name of the postgres server to apply this rule to"
}

variable "ip_address_list" {
  type        = list
  description = "list of single IP addresses to whitelist for access"
}