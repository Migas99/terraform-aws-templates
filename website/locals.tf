locals {
  is_production                         = var.environment == "production" || var.environment == "prod" ? true : false

  website_route_53_record_name          = "${var.subdomain}.${var.domain}"
  website_redirect_route_53_record_name = "${var.domain}"

  website_bucket_name                   = "${var.subdomain}.${var.domain}"
  website_logs_bucket_name              = "logs.${var.subdomain}.${var.domain}"
  website_redirect_bucket_name          = "${var.domain}"
  
  tags = {
    "Created by"       = "Terraform"
    "Managed by"       = "Terraform"
    Service            = "terraform-aws-website-module"
    "Deployed Service" = "${var.deployed_service}"
    Environment        = "${var.environment}"
  }
}