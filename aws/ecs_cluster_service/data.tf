data "aws_vpc" "vpc" {
  tags = {
    Environment = var.environment
  }
}

data "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = var.cluster_name
}

data "aws_alb" "alb" {
  name = var.alb_name
}

data "aws_caller_identity" "current" {}

data "aws_lb_listener" "http_listener" {
  load_balancer_arn = data.aws_alb.alb.arn
  port              = data.aws_caller_identity.current.account_id == "000000000000" ? 4566 : 80
}

data "aws_lb_listener" "https_listener" {
  load_balancer_arn = data.aws_alb.alb.arn
  port              = 443
}

data "aws_ecs_task_definition" "task_definition" {
  task_definition = var.task_arn
}

data "aws_subnet" "private_subnet_1" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "cidr-block"
    values = ["10.0.101.0/24"]
  }
}

data "aws_subnet" "private_subnet_2" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "cidr-block"
    values = ["10.0.102.0/24"]
  }
}

data "aws_subnet" "private_subnet_3" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "cidr-block"
    values = ["10.0.103.0/24"]
  }
}

data "aws_security_group" "ecs_security_group" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "group-name"
    values = ["${var.cluster_name}-cluster-sg"]
  }
}

locals {
  cluster_arn         = data.aws_ecs_cluster.ecs_cluster.arn
  private_subnet_1_id = data.aws_subnet.private_subnet_1.id
  private_subnet_2_id = data.aws_subnet.private_subnet_2.id
  private_subnet_3_id = data.aws_subnet.private_subnet_3.id
  ecs_sg_id           = data.aws_security_group.ecs_security_group.id
  container_name      = jsondecode(data.aws_ecs_task_definition.task_definition.container_definitions)[0].name
}
