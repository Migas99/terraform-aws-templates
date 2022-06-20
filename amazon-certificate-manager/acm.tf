resource "aws_acm_certificate" "certificate" {
    domain_name               = var.domain
    subject_alternative_names = ["*.${var.domain}"]
    validation_method         = "DNS"
    tags                      = local.tags

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_acm_certificate_validation" "certificate_validation" {
    certificate_arn         = aws_acm_certificate.certificate.arn
    validation_record_fqdns = [for r in aws_route53_record.certificate_validation : r.fqdn]
}

