# locals {
#   records = [1,2,3]
# }

resource "aws_route53_record" "mx_dkim_arc" {
  count   = 3
  zone_id = var.zone_id
  # for_each = local.records
  # for_each = {
  #   for record in local.records :
  # }
  # name    = "key${each.value}._domainkey"
  name = "key${count.index + 1}._domainkey"
  type = "CNAME"
  ttl  = "300"
  records = [
    # "key${each.value}.commonplacepurpose.com._domainkey.migadu.com."
    "key${count.index + 1}.commonplacepurpose.com._domainkey.migadu.com."
  ]
}




resource "aws_route53_record" "mx" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "MX"
  ttl     = "300"
  records = var.mx
}

resource "aws_route53_record" "mx_spf" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "TXT"
  ttl     = "300"
  records = [var.mx_spf]
}

resource "aws_route53_record" "mx_spf_spf" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "SPF"
  ttl     = "300"
  records = [var.mx_spf]
}

resource "aws_route53_record" "mx_txt" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "TXT"
  ttl     = "300"
  records = [var.mx_txt]
}

resource "aws_route53_record" "mx_dmarc" {
  zone_id = var.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = "300"
  records = [var.mx_dmarc]
}
