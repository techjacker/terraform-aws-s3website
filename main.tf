module "dnszone" {
  source = "./dnszone"
  domain = var.domain
}

module "s3website" {
  source                        = "./s3website"
  domain                        = var.domain
  zone_id                       = var.route53_zone_id
  cdn_min_ttl                   = var.cdn_min_ttl
  cdn_default_ttl               = var.cdn_default_ttl
  cdn_max_ttl                   = var.cdn_max_ttl
  enable_health_check           = var.enable_health_check
  health_check_alarm_sns_topics = var.health_check_alarm_sns_topics
  enable_gzip                   = var.enable_gzip
}

module "mx" {
  source   = "./mx"
  zone_id  = var.route53_zone_id
  domain   = var.domain
  mx       = var.mx
  mx_spf   = var.mx_spf
  mx_dkim  = var.mx_dkim
  mx_dmarc = var.mx_dmarc
}
