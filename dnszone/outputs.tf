output "name_servers" {
  value = [
    "${aws_route53_zone.main.name_servers.0}",
    "${aws_route53_zone.main.name_servers.1}",
    "${aws_route53_zone.main.name_servers.2}",
    "${aws_route53_zone.main.name_servers.3}",
  ]

  description = "The AWS Name Servers to plug in to your domain registrar"
}

output "zone_id" {
  value       = aws_route53_zone.main.id
  description = "The created DNS zone ID"
}
