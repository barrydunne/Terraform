resource "aws_route53_record" "cname" {
  zone_id = local.hosted_zone_id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = 300
  records = [data.aws_alb.alb.dns_name]
}