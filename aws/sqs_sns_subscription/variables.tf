variable "queue_arn" {
  description = "The ARN of the SQS queue that will be subscribed to the SNS topic."
  type        = string
  default     = null
}

variable "topic_arn" {
  description = "The ARN of the SNS topic to subscribe the SQS queue to."
  type        = string
  default     = null
}
