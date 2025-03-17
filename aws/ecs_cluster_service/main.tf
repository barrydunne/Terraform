resource "aws_lb_target_group" "target_group" {
  count       = var.enable_load_balancer ? 1 : 0
  name        = "${var.cluster_service_name}-tg"
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
  }
}

resource "aws_lb_listener_rule" "http_rule" {
  count        = var.enable_load_balancer ? max(length(var.listener_rule_path), 1) : 0
  listener_arn = data.aws_lb_listener.http_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[0].arn
  }
  dynamic "condition" {
    for_each = var.listener_rule_host != "" ? [1] : []
    content {
      host_header {
        values = [var.listener_rule_host]
      }
    }
  }
  dynamic "condition" {
    for_each = length(var.listener_rule_path) > 0 ? [var.listener_rule_path[count.index]] : []
    content {
      path_pattern {
        values = [condition.value]
      }
    }
  }
  lifecycle {
    precondition {
      condition     = var.listener_rule_host != "" || length(var.listener_rule_path) > 0
      error_message = "At least one of listener_rule_host or listener_rule_path must be provided."
    }
  }
}

resource "aws_lb_listener_rule" "https_rule" {
  count        = var.enable_load_balancer ? max(length(var.listener_rule_path), 1) : 0
  listener_arn = data.aws_lb_listener.https_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[0].arn
  }
  dynamic "condition" {
    for_each = var.listener_rule_host != "" ? [1] : []
    content {
      host_header {
        values = [var.listener_rule_host]
      }
    }
  }
  dynamic "condition" {
    for_each = length(var.listener_rule_path) > 0 ? [var.listener_rule_path[count.index]] : []
    content {
      path_pattern {
        values = [condition.value]
      }
    }
  }
  lifecycle {
    precondition {
      condition     = var.listener_rule_host != "" || length(var.listener_rule_path) > 0
      error_message = "At least one of listener_rule_host or listener_rule_path must be provided."
    }
  }
}

resource "aws_ecs_service" "service" {
  name                              = var.cluster_service_name
  cluster                           = local.cluster_arn
  task_definition                   = var.task_arn
  launch_type                       = "FARGATE"
  desired_count                     = var.minimum_containers
  health_check_grace_period_seconds = 0
  availability_zone_rebalancing     = "DISABLED"

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    assign_public_ip = false
    subnets = [
      local.private_subnet_1_id,
      local.private_subnet_2_id,
      local.private_subnet_3_id
    ]
    security_groups = [
      local.ecs_sg_id
    ]
  }

  dynamic "load_balancer" {
    for_each = var.enable_load_balancer ? [1] : []
    content {
      target_group_arn = aws_lb_target_group.target_group[0].arn
      container_name   = local.container_name
      container_port   = var.port
    }
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 0
  }

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  tags = {
    Environment = var.environment
  }
  lifecycle {
    ignore_changes = [tags, tags_all, capacity_provider_strategy, availability_zone_rebalancing]
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.maximum_containers
  min_capacity       = var.minimum_containers
  resource_id        = "service/${var.cluster_name}/${var.cluster_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "${var.cluster_service_name}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.cpu_scaling_percent
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "${var.cluster_service_name}-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.memory_scaling_percent
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}