output "name_servers" {
  value = [
    "${module.dnszone.name_servers.0}",
    "${module.dnszone.name_servers.1}",
    "${module.dnszone.name_servers.2}",
    "${module.dnszone.name_servers.3}",
  ]

  description = "The AWS Name Servers to plug in to your domain registrar"
}

output "zone_id" {
  value       = "${module.dnszone.zone_id}"
  description = "The created DNS zone ID"
}
