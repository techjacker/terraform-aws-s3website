output "name_servers" {
  value       = module.dnszone.name_servers
  description = "The AWS Name Servers to plug in to your domain registrar"
}

output "zone_id" {
  value       = module.dnszone.zone_id
  description = "The created DNS zone ID"
}
