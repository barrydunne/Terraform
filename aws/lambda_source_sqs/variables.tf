variable "function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "queue_arn" {
  description = "The ARN of the SQS queue to attach the Lambda function to."
  type        = string
}

variable "batch_size" {
  description = "The maximum number of records to include in a single batch when polling for records from the SQS queue."
  type        = number
  default     = 10
}

variable "maximum_batching_window_in_seconds" {
  description = "The maximum amount of time to gather records before invoking the Lambda function."
  type        = number
  default     = 2
}

variable "report_batch_item_failures" {
  description = "Whether to enable ReportBatchItemFailures for the Lambda event source mapping"
  type        = bool
  default     = false
}