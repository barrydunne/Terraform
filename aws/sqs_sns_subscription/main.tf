resource "aws_sns_topic_subscription" "sns_subscription" {
  topic_arn            = var.topic_arn
  protocol             = "sqs"
  endpoint             = var.queue_arn
  raw_message_delivery = true
}
