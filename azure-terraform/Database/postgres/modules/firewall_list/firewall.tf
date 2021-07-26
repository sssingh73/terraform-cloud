resource "azurerm_postgresql_firewall_rule" "database_firewall_rule_list" {
  name                = element(var.rule_name_list, count.index)
  resource_group_name = var.resource_group_name
  server_name         = var.postgres_server_name
  start_ip_address    = element(var.ip_address_list, count.index)
  end_ip_address      = element(var.ip_address_list, count.index)

  count               = length(var.ip_address_list)
}