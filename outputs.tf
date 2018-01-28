output "name_servers" {
  value = [
    "${module.dnszone.name_servers.0}",
    "${module.dnszone.name_servers.1}",
    "${module.dnszone.name_servers.2}",
    "${module.dnszone.name_servers.3}",
  ]
}

output "zone_id" {
  value = "${module.dnszone.zone_id}"
}
