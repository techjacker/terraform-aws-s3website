# data "aws_region" "current" {
#   current = true
# }

# http://example.com.s3-website-eu-west-1.amazonaws.com/
variable "domain" {
  description = "The domain where to host the site. This must be the naked domain, e.g. `example.com`"
}

variable "zone_id" {
  description = "route53 hosted zone id"
}

variable "cdn_min_ttl" {
  description = "Cloudfront minimum TTL Default = 0 seconds."
  default     = 0
}

variable "cdn_default_ttl" {
  description = "Cloudfront default TTL. Default = 86400 seconds (1 hour)."
  default     = 3600

  # 1 day
  # default     = 86400
}

variable "cdn_max_ttl" {
  description = "Cloudfront maximum TTL. Default = 31536000 seconds (365 days)."
  default     = 31536000
}

variable "enable_health_check" {
  type        = "string"
  default     = false
  description = "If true, it creates a Route53 health check that monitors the www endpoint and an alarm that triggers whenever it's not reachable. Please note this comes at an extra monthly cost on your AWS account"
}

variable "health_check_alarm_sns_topics" {
  type        = "list"
  default     = []
  description = "A list of SNS topics to notify whenever the health check fails or comes back to normal"
}

variable "enable_gzip" {
  type        = "string"
  default     = true
  description = "Whether to make CloudFront automatically compress content for web requests that include `Accept-Encoding: gzip` in the request header"
}
