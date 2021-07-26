# in main.tf database service naming follows below pattern
# ${var.business_unit_group}-${var.app_name}-${resource_group_location}-${var.environment}-database-service
# please change the pattern in main.tf if you need any other naming conventeion

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


