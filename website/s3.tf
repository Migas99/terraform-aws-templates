resource "aws_s3_bucket" "website" {
  bucket = local.website_bucket_name
  tags   = local.tags
}

resource "aws_s3_bucket_acl" "website" {
  bucket = aws_s3_bucket.website.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website_bucket_policy.json
}

resource "aws_s3_bucket" "website_logs" {
  bucket        = local.website_logs_bucket_name
  tags          = local.tags
}

resource "aws_s3_bucket_acl" "website_logslogs" {
  bucket = aws_s3_bucket.website_logs.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_public_access_block" "website_logs" {
  bucket                  = aws_s3_bucket.website_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "website" {
  bucket        = aws_s3_bucket.website.id
  target_bucket = aws_s3_bucket.website_logs.id
  target_prefix = "bucket-logs/"
}

resource "aws_s3_bucket" "redirect" {
  count  = local.is_production ? 1 : 0
  bucket = local.website_redirect_bucket_name
  tags   = local.tags
}

resource "aws_s3_bucket_acl" "redirect" {
  count  = local.is_production ? 1 : 0
  bucket = aws_s3_bucket.redirect[0].id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "redirect" {
  count  = local.is_production ? 1 : 0
  bucket = aws_s3_bucket.redirect[0].id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "redirect" {
  count  = local.is_production ? 1 : 0
  bucket = aws_s3_bucket.redirect[0].id
  policy = data.aws_iam_policy_document.redirect_bucket_policy[0].json
}

resource "aws_s3_bucket_website_configuration" "redirect" {
  count  = local.is_production ? 1 : 0
  bucket = aws_s3_bucket.redirect[0].id

  redirect_all_requests_to {
    host_name = aws_route53_record.website.name
    protocol  = "https"
  }
}