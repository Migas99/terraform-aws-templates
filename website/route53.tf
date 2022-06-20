resource "aws_route53_record" "website" {
  name    = local.website_route_53_record_name
  zone_id = data.aws_route53_zone.domain.zone_id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "redirect" {
  count   = local.is_production ? 1 : 0
  name    = local.website_redirect_route_53_record_name
  zone_id = data.aws_route53_zone.domain.zone_id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.redirect_s3_distribution[0].domain_name
    zone_id                = aws_cloudfront_distribution.redirect_s3_distribution[0].hosted_zone_id
    evaluate_target_health = true
  }
}

