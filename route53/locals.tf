locals {
  tags = {
    "Created by"       = "Terraform"
    "Managed by"       = "Terraform"
    Service            = "terraform-route53"
    "Deployed Service" = "${var.deployed_service}"
  }
}