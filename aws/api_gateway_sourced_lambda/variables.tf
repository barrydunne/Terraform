variable "environment" {
  description = "The environment to deploy the resources to."
  type        = string
  default     = "local"
}

variable "function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "function_handler" {
  description = "The full name of the Lambda function handler."
  type        = string
}

variable "function_zip_path" {
  description = "The path to the zip file containing the Lambda function code."
  type        = string
}

variable "function_runtime" {
  description = "The runtime to use for the Lambda function, for example 'dotnet8'."
  type        = string
  default     = "dotnet8"
}

variable "function_architectures" {
  description = "The architecture the Lambda function was built for."
  type        = list(string)
  default     = ["arm64"]
}

variable "function_memory_size" {
  description = "The amount of memory to allocate to the Lambda function."
  type        = number
  default     = 128
}

variable "function_timeout" {
  description = "The amount of time the Lambda function has to run before it is terminated."
  type        = number
  default     = 120
}

variable "function_version" {
  description = "The version of the Lambda function."
  type        = string
  default     = "1.0.0"
}

variable "api_gateway_path" {
  description = "The path to use in API Gateway to connect to the Lambda function."
  type        = string
  default     = "/lambda"
}

variable "aspnetcore_environment" {
  description = "The ASPNETCORE_ENVIRONMENT to use for the Lambda."
  type        = string
  default     = "Development"
}
