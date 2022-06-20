resource "aws_route53_record" "certificate_validation" {
    for_each = {
        for d in aws_acm_certificate.certificate.domain_validation_options : d.domain_name => {
            name   = d.resource_record_name
            record = d.resource_record_value
            type   = d.resource_record_type
        }
    }

    allow_overwrite = true
    name            = each.value.name
    records         = [each.value.record]
    ttl             = 60
    type            = each.value.type
    zone_id         = data.aws_route53_zone.domain.zone_id
}

