variable "records" {
  description = "Map with IP nodes and managers"
}
variable "domain" {
  description = "Name of main dns domain"
}
variable "group_name" {
  description = "Azure group name"
}

data "azurerm_dns_zone" "zone" {
  name                = var.domain
  resource_group_name = var.group_name
}

resource "azurerm_dns_a_record" "managers" {
  count               = length(var.records.managers)
  name                = "manager-${count.index}"
  zone_name           = data.azurerm_dns_zone.zone.name
  resource_group_name = var.group_name
  ttl                 = 300
  records             = [var.records.managers[count.index]]
}

resource "azurerm_dns_a_record" "main" {
  name                = "@"
  zone_name           = data.azurerm_dns_zone.zone.name
  resource_group_name = var.group_name
  ttl                 = 300
  records             = var.records.managers
}

resource "azurerm_dns_a_record" "workers" {
  count               = length(var.records.workers)
  name                = "node-${count.index}"
  zone_name           = data.azurerm_dns_zone.zone.name
  resource_group_name = var.group_name
  ttl                 = 300
  records             = [var.records.workers[count.index]]
}
