# terraform-aws-templates

This project contains templates that can be re-used by anyone to setup infrastructure in AWS for common services such as Route53, ACM and setting up a standard website, using Cloudfront and S3.

# route53

Terraform template that will create new domains in Route53.

Example usage (by creating a custom ``main.tf`` file that defines as module source this repository):

```
terraform {
  backend "s3" {
    bucket = "__TERRAFORM_BUCKET_NAME_PLACEHOLDER__"
    key    = "__SERVICE_PLACEHOLDER__/__TERRAFORM_STATE_FILE_NAME_PLACEHOLDER__"
    region = "__AWS_REGION_PLACEHOLDER__"
    acl    = "bucket-owner-full-control"
  }
}

module "infrastructure" {
  source            = "git@github.com:Migas99/terraform-aws-templates.git//route53"
  for_each          = toset([__DOMAINS_PLACEHOLDER__])
  deployed_service  = "__SERVICE_PLACEHOLDER__"
  domain            = each.value
}
```

Aside from the field ``source`` in the ``module`` block, everything else can be customized.

We allow to be passed in a list of domains to create.

# amazon-certificate-manager

Terraform template that will create new certificates for the given domains already created in ``Route53``.

Example usage (by creating a custom ``main.tf`` file that defines as module source this repository):

```
terraform {
  backend "s3" {
    bucket = "__TERRAFORM_BUCKET_NAME_PLACEHOLDER__"
    key    = "__SERVICE_PLACEHOLDER__/__TERRAFORM_STATE_FILE_NAME_PLACEHOLDER__"
    region = "__AWS_REGION_PLACEHOLDER__"
    acl    = "bucket-owner-full-control"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "infrastructure" {
  source            = "git@github.com:Migas99/terraform-aws-templates.git//amazon-certificate-manager"
  for_each          = toset([__DOMAINS_PLACEHOLDER__])
  deployed_service  = "__SERVICE_PLACEHOLDER__"
  domain            = each.value
}
```

Aside from the field ``source`` in the ``module`` block, everything else can be customized.

We allow to be passed in a list of domains.

# website

Terraform template that creates all te infrastructure needed to host a website using AWS services such as Cloudfront and S3.

Example usage (by creating a custom ``main.tf`` file that defines as module source this repository):

```
terraform {
  backend "s3" {
    bucket = "__TERRAFORM_BUCKET_NAME_PLACEHOLDER__"
    key    = "__SERVICE_PLACEHOLDER__/__ENVIRONMENT_PLACEHOLDER__/__TERRAFORM_STATE_FILE_NAME__"
    region = "__AWS_REGION_PLACEHOLDER__"
    acl    = "bucket-owner-full-control"
  }
}

provider "aws" {
    region = "__AWS_REGION_PLACEHOLDER__"
}

module "configuration" {
  source           = "git@github.com:Migas99/terraform-aws-templates.git//website"
  deployed_service = "__SERVICE_PLACEHOLDER__"
  environment      = "__ENVIRONMENT_PLACEHOLDER__"
  domain           = "__DOMAIN_PLACEHOLDER__"
  subdomain        = "__SUBDOMAIN_PLACEHOLDER__"
  cache_ttl        = "__CACHE_TTL_PLACEHOLDER__"
}
```

Aside from the field ``source`` in the ``module`` block, everything else can be customized.

This template will assume that the passed in parameter ``domain`` is already configured in ``Route53`` and has a valid certificate.
