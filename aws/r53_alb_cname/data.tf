data "aws_route53_zone" "r53_zone" {
  name = local.domain_suffix
}

data "aws_alb" "alb" {
  name = var.alb_name
}

locals {
  domain_suffix  = regex("[^.]+\\.[^.]+$", var.domain_name)
  hosted_zone_id = data.aws_route53_zone.r53_zone.zone_id
}