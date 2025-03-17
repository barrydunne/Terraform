variable "environment" {
  description = "The environment to deploy the resources to."
  type        = string
  default     = "local"
}

variable "function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "handler" {
  description = "The full name of the Lambda function handler."
  type        = string
}

variable "function_version" {
  description = "The version of the Lambda function."
  type        = string
  default     = "1.0.0"
}

variable "runtime" {
  description = "The runtime to use for the Lambda function, for example 'dotnet8'."
  type        = string
  default     = "dotnet8"
}

variable "architectures" {
  description = "The architecture the Lambda function was built for."
  type        = list(string)
  default     = ["arm64"]
}

variable "memory_size" {
  description = "The amount of memory to allocate to the Lambda function."
  type        = number
  default     = 128
}

variable "timeout" {
  description = "The amount of time the Lambda function has to run before it is terminated."
  type        = number
  default     = 120
}

variable "zip_path" {
  description = "The path to the zip file containing the Lambda function code."
  type        = string
}

variable "iam_role" {
  description = "The IAM role to assign to the Lambda function."
  type        = any
}

variable "environment_variables" {
  description = "Environment variables to apply to the Lambda function."
  type        = map(string)
}

variable "aspnetcore_environment" {
  description = "The ASPNETCORE_ENVIRONMENT to use for the Lambda."
  type        = string
  default     = "Development"
}
