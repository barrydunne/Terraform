variable "environment" {
  description = "The environment to deploy the resources to."
  type        = string
  default     = "local"
}

variable "cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
}

variable "cluster_service_name" {
  description = "The name of the ECS cluster service."
  type        = string
}

variable "task_arn" {
  description = "The ARN of the ECS task definition."
  type        = string
}

variable "minimum_containers" {
  description = "Minimum number of ECS tasks per ECS service."
  type        = string
  default     = 1
}

variable "maximum_containers" {
  description = "Maximum number of ECS tasks per ECS service."
  type        = string
  default     = 10
}

variable "cpu_scaling_percent" {
  description = "Target CPU utilization (%) for ECS services auto scaling."
  type        = string
  default     = 80
}

variable "memory_scaling_percent" {
  description = "Target memory utilization (%) for ECS services auto scaling."
  type        = string
  default     = 80
}

variable "enable_load_balancer" {
  description = "Whether to enable the load balancer and related resources"
  type        = bool
  default     = false
}

variable "alb_name" {
  description = "The name of the Application Load Balancer."
  type        = string
  default     = ""
}

variable "health_check_path" {
  description = "The health check path for the service."
  type        = string
  default     = "/"
}

variable "port" {
  description = "The port to use for the target group."
  type        = number
  default     = 8080
}

variable "listener_rule_host" {
  description = "The listener rule host header condition for the Application Load Balancer."
  type        = string
  default     = ""
}

variable "listener_rule_path" {
  description = "The listener rule path prefix condition for the Application Load Balancer. For example [\"/api\", \"/api/*\"]"
  type        = list(string)
  default     = []
}
