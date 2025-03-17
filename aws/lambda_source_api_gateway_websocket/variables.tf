variable "environment" {
  description = "The environment to deploy the resources to."
  type        = string
  default     = "local"
}

variable "function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "function_invoke_arn" {
  description = "The invoke ARN of the Lambda function."
  type        = string
}

variable "api_gateway_path" {
  description = "The path to use in API Gateway to connect to the Lambda function."
  type        = string
  default     = "/lambda"
}
