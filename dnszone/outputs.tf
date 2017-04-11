output "name_servers" {
  value = [
    "${aws_route53_zone.main.name_servers.0}",
    "${aws_route53_zone.main.name_servers.1}",
    "${aws_route53_zone.main.name_servers.2}",
    "${aws_route53_zone.main.name_servers.3}",
  ]
}
output "zone_id" {
  value = "${aws_route53_zone.main.id}"
}
