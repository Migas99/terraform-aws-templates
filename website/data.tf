data "aws_route53_zone" "domain" {
  name = var.domain
}

data "aws_acm_certificate" "certificate" {
  provider = aws.us-east-1
  domain   = var.domain
  types    = ["AMAZON_ISSUED"]
}

data "aws_iam_policy_document" "website_bucket_policy" {
  statement {
    actions    = ["s3:GetObject"]

    principals {
      type = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.oai.iam_arn}"]
    }

    resources  = ["${aws_s3_bucket.website.arn}/*"]
  }
}

data "aws_iam_policy_document" "redirect_bucket_policy" {
  count  = local.is_production ? 1 : 0
  statement {
    actions    = ["s3:GetObject"]

    principals {
      type = "AWS"
      identifiers = ["*"]
    }

    resources  = ["${aws_s3_bucket.redirect[0].arn}/*"]
  }
}

