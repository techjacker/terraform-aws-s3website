terraform {
  backend "s3" {
    bucket         = "distinctplatform-tf-state"
    key            = "terraform-aws-s3website/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = "true"
    dynamodb_table = "distinctplatform-terraform-locks"
  }
}
