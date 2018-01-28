module "dnszone" {
  source = "./dnszone"
  domain = "${var.domain}"
}

module "s3website" {
  source                        = "./s3website"
  domain                        = "${var.domain}"
  enable_health_check           = "${var.enable_health_check}"
  health_check_alarm_sns_topics = "${var.health_check_alarm_sns_topics}"
  enable_gzip                   = "${var.enable_gzip}"
  zone_id                       = "${module.dnszone.zone_id}"
}

module "mx" {
  source   = "./mx"
  zone_id  = "${module.dnszone.zone_id}"
  domain   = "${var.domain}"
  mx       = "${var.mx}"
  mx_spf   = "${var.mx_spf}"
  mx_dkim  = "${var.mx_dkim}"
  mx_dmarc = "${var.mx_dmarc}"
}
