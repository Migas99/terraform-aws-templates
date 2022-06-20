locals {
  tags = {
    "Created by"       = "Terraform"
    "Managed by"       = "Terraform"
    Service            = "terraform-amazon-certificate-manager"
    "Deployed Service" = "${var.deployed_service}"
  }
}