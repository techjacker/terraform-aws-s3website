variable "zone_id" {
  description = "route53 hosted zone id"
}

variable "domain" {
  description = "route53 hosted zone domain name"
}

variable "mx" {
  type = list(string)
}

variable "mx_spf" {}
variable "mx_txt" {}
variable "mx_dmarc" {}

variable "google_site_verification" {
  description = "DNS TXT record value to create for google site verification"
  default     = ""
}
