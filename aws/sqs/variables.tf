variable "queue_name" {
  description = "The name of the SQS queue."
  type        = string
}

variable "dlq_name" {
  description = "The optional name of the SQS dead-letter queue. If not provided no dead-letter queue will be created."
  type        = string
  default     = null
}

variable "visibility_timeout" {
  description = "The visibility timeout for the SQS queue."
  type        = number
  default     = 30
}

variable "max_receive_count" {
  description = "The maximum number of times a message can be received before being sent to the dead-letter queue."
  type        = number
  default     = 3
}
