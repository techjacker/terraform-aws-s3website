variable "zone_id" {
  description = "route53 hosted zone id"
}

variable "domain" {
  description = "route53 hosted zone domain name"
}

variable "mx" {
  type = "list"
}

variable "mx_spf" {}
variable "mx_dkim" {}
variable "mx_dmarc" {}
