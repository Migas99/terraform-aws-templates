resource "aws_cloudfront_distribution" "s3_distribution" {

    aliases             = [local.website_bucket_name ]
    enabled             = true
    is_ipv6_enabled     = true
    comment             = "Created by Terraform"
    default_root_object = "index.html"
    price_class         = "PriceClass_100"
    tags                = local.tags

    origin {
        domain_name = aws_s3_bucket.website.bucket_regional_domain_name
        origin_id   = aws_s3_bucket.website.bucket_regional_domain_name

        s3_origin_config {
            origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
        }
    }

    custom_error_response {
      error_code         = 403
      response_code      = 200
      response_page_path = "/index.html"
    }

    custom_error_response {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    }

    ordered_cache_behavior {
        path_pattern     = "/assets/*"
        allowed_methods  = ["GET", "HEAD", "OPTIONS"]
        cached_methods   = ["GET", "HEAD", "OPTIONS"]
        target_origin_id = aws_s3_bucket.website.bucket_regional_domain_name

        forwarded_values {
            query_string = false
            headers      = ["Origin"]

            cookies {
                forward = "none"
            }
        }

        min_ttl                = 0
        default_ttl            = var.cache_ttl
        max_ttl                = var.cache_ttl
        compress               = true
        viewer_protocol_policy = "redirect-to-https"
    }

    ordered_cache_behavior {
        path_pattern     = "favicon.ico"
        allowed_methods  = ["GET", "HEAD", "OPTIONS"]
        cached_methods   = ["GET", "HEAD", "OPTIONS"]
        target_origin_id = aws_s3_bucket.website.bucket_regional_domain_name

        forwarded_values {
            query_string = false
            headers      = ["Origin"]

            cookies {
                forward = "none"
            }
        }

        min_ttl                = 0
        default_ttl            = var.cache_ttl
        max_ttl                = var.cache_ttl
        compress               = true
        viewer_protocol_policy = "redirect-to-https"
    }

    logging_config {
      include_cookies = false
      bucket = aws_s3_bucket.website_logs.bucket_domain_name
      prefix = "cloudfront-access/"
    }

    default_cache_behavior {
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = aws_s3_bucket.website.bucket_regional_domain_name

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl                = 0
        default_ttl            = var.cache_ttl
        max_ttl                = var.cache_ttl
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        acm_certificate_arn      = data.aws_acm_certificate.certificate.arn
        ssl_support_method       = "sni-only"
        minimum_protocol_version = "TLSv1.2_2021"
    }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
    comment = "OAI for ${local.website_bucket_name}"
}

resource "aws_cloudfront_distribution" "redirect_s3_distribution" {
    count               = local.is_production ? 1 : 0
    aliases             = [local.website_redirect_bucket_name]
    enabled             = true
    is_ipv6_enabled     = true
    comment             = "Created by Terraform"
    price_class         = "PriceClass_100"
    tags                = local.tags

    origin {
        domain_name = aws_s3_bucket.redirect[0].website_endpoint
        origin_id   = aws_s3_bucket.redirect[0].website_endpoint

        custom_origin_config {
            http_port              = "80"
            https_port             = "443"
            origin_protocol_policy = "http-only"
            origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
        }
    }

    default_cache_behavior {
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = aws_s3_bucket.redirect[0].website_endpoint

        forwarded_values {
            query_string = true

            cookies {
                forward = "none"
            }
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl                = 0
        default_ttl            = var.cache_ttl
        max_ttl                = var.cache_ttl
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        acm_certificate_arn      = data.aws_acm_certificate.certificate.arn
        ssl_support_method       = "sni-only"
        minimum_protocol_version = "TLSv1.2_2021"
    }
}

