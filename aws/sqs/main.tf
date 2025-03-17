resource "aws_sqs_queue" "dlq" {
  count                      = (var.dlq_name != null && length(var.dlq_name) > 0) ? 1 : 0
  name                       = var.dlq_name
  visibility_timeout_seconds = var.visibility_timeout
}

resource "aws_sqs_queue" "queue" {
  name                       = var.queue_name
  visibility_timeout_seconds = var.visibility_timeout

  redrive_policy = var.dlq_name == null ? null : jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  })
}
