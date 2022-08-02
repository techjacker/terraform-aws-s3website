####################
# bool vars
####################
variable enable_website {
  type        = bool
  default     = false
  description = "Enable the website (you need to have plugged in route53 zone nameservers into your domain registrar prior to enabling this)"
}

####################
# S3Website module
####################
variable "domain" {
  description = "The domain where to host the site. This must be the naked domain, e.g. `example.com`"
}

variable "route53_zone_id" {
  description = "route53 hosted zone id"
}

variable "cdn_min_ttl" {
  description = "Cloudfront minimum TTL Default = 0 seconds."
  default     = 0
}

variable "cdn_default_ttl" {
  description = "Cloudfront default TTL. Default = 86400 seconds (24 hours)."
  default     = 86400
}

variable "cdn_max_ttl" {
  description = "Cloudfront maximum TTL. Default = 31536000 seconds (365 days)."
  default     = 31536000
}

variable "enable_health_check" {
  type        = string
  default     = false
  description = "If true, it creates a Route53 health check that monitors the www endpoint and an alarm that triggers whenever it's not reachable. Please note this comes at an extra monthly cost on your AWS account"
}

variable "health_check_alarm_sns_topics" {
  type        = list(string)
  default     = []
  description = "A list of SNS topics to notify whenever the health check fails or comes back to normal"
}

variable "enable_gzip" {
  type        = string
  default     = true
  description = "Whether to make CloudFront automatically compress content for web requests that include `Accept-Encoding: gzip` in the request header"
}

####################
# MX module
####################
variable "mx" {
  type = list(string)
}

variable "mx_spf" {}
variable "mx_txt" {}
variable "mx_dmarc" {}
