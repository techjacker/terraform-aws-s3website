module "dnszone" {
  source = "./dnszone"
  domain = var.domain
}

module "s3website" {
  count = var.enable_website ? 1 : 0
  source                        = "./s3website"
  domain                        = var.domain
  zone_id                       = module.dnszone.zone_id
  cdn_min_ttl                   = var.cdn_min_ttl
  cdn_default_ttl               = var.cdn_default_ttl
  cdn_max_ttl                   = var.cdn_max_ttl
  enable_health_check           = var.enable_health_check
  health_check_alarm_sns_topics = var.health_check_alarm_sns_topics
  enable_gzip                   = var.enable_gzip
}

module "mx" {
  source   = "./mx"
  zone_id  = module.dnszone.zone_id
  domain   = var.domain
  mx       = var.mx
  mx_spf   = var.mx_spf
  mx_txt   = var.mx_txt
  mx_dmarc = var.mx_dmarc
}
