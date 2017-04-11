# Terraform Modules


## Example Usage

```HCL
module "dnszone" {
  source    = "git@github.com:techjacker/terraform//dnszone"
  domain    = "${var.domain}"
}

module "mx" {
  source    = "git@github.com:techjacker/terraform//mx"
  zone_id   = "${module.dnszone.zone_id}"
  domain    = "${var.domain}"
  mx        = "${var.mx}"
  mx_spf    = "${var.mx_spf}"
  mx_dkim   = "${var.mx_dkim}"
  mx_dmarc  = "${var.mx_dmarc}"
}
```
