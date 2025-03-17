output "queue_arn" {
  description = "The ARN of the queue."
  value       = aws_sqs_queue.queue.arn
}

output "queue_url" {
  description = "The URL of the queue."
  value       = aws_sqs_queue.queue.id
}

output "dlq_arn" {
  description = "The ARN of the dead-letter queue, if created)."
  value       = can(aws_sqs_queue.dlq[0].arn) ? aws_sqs_queue.dlq[0].arn : null
}

output "dlq_url" {
  description = "The URL of the dead-letter queue, if created."
  value       = can(aws_sqs_queue.dlq[0].id) ? aws_sqs_queue.dlq[0].id : null
}
