variable "deployed_service" {
  description = "Name of the service about to be deployed"
  type        = string
}

variable "environment" {
  description = "Environment of the service about to be deployed (production, preprod, qa or development)"
  type        = string
}

variable "domain" {
  description = "Website domain"
  type        = string
}

variable "subdomain" {
  description = "Website subdomain"
  type        = string
}

variable "cache_ttl" {
  description = "Cache time for a resource in Cloudfront. If the value is 0, cache is disabled."
  default = 0 # 0 for development / qa, but should be 1800 for preprod / production
}