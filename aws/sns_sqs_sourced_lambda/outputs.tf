output "function_arn" {
  value = module.lambda_function.function_arn
}
output "queue_url" {
  value = module.sqs_queue.queue_url
}

output "dlq_url" {
  value = module.sqs_queue.dlq_url
}

output "iam_role_arn" {
  value = module.iam_role.role.arn
}

output "iam_role_name" {
  value = module.iam_role.role.name
}
