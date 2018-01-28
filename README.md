# Terraform Modules


## Example Usage


### 1. Update `.env` file values
```Shell
DOMAIN="example.com"
```


### 2. Create TLS certificate
```Shell
./bin/aws-tls-certificate.sh
```


### 3. Confirm ownership of domain to activate the TLS Certificate
Click on the link AWS will email to you to verify ownership of the domain and activate the certificate.


### 4. Update terraform `main.tf` to include modules from this repo
```HCL
module "dnszone" {
  source    = "git@github.com:techjacker/terraform//dnszone"
  domain    = "${var.domain}"
}

module "s3website" {
  source    			 = "git@github.com:techjacker/terraform//s3website"
  domain    			 = "${var.domain}"
  zone_id   			 = "${module.dnszone.zone_id}"
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


### 5. Run terraform

```Shell
terraform env new prod
terraform env select prod
terraform get
terraform plan
terraform apply
`
