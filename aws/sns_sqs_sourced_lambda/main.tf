module "sqs_queue" {
  source             = "git::https://github.com/barrydunne/Terraform.git//aws/sqs"
  queue_name         = var.queue_name != "" ? var.queue_name : "${var.function_name}-sqs"
  dlq_name           = var.queue_name != "" ? "${var.queue_name}-dlq" : "${var.function_name}-sqs-dlq"
  visibility_timeout = 30
  max_receive_count  = 3
}

module "iam_role" {
  source            = "git::https://github.com/barrydunne/Terraform.git//aws/iam_role"
  role_name         = "${var.function_name}-role"
  attach_policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

module "lambda_function" {
  source                 = "git::https://github.com/barrydunne/Terraform.git//aws/lambda"
  environment            = var.environment
  function_name          = var.function_name
  function_version       = var.function_version
  handler                = var.function_handler
  runtime                = var.function_runtime
  architectures          = var.function_architectures
  memory_size            = var.function_memory_size
  timeout                = var.function_timeout
  zip_path               = var.function_zip_path
  iam_role               = module.iam_role.role
  aspnetcore_environment = var.aspnetcore_environment
  environment_variables  = var.environment_variables

  depends_on = [module.sqs_queue, module.iam_role]
}

module "lambda_source" {
  source                             = "git::https://github.com/barrydunne/Terraform.git//aws/lambda_source_sqs"
  function_name                      = module.lambda_function.function_name
  queue_arn                          = module.sqs_queue.queue_arn
  batch_size                         = 5
  maximum_batching_window_in_seconds = 5
  report_batch_item_failures         = true

  depends_on = [module.lambda_function]
}

resource "aws_sqs_queue_policy" "queue_policy" {
  queue_url = module.sqs_queue.queue_url
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        },
        Action   = "sqs:SendMessage",
        Resource = module.sqs_queue.queue_arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" : var.subscription_topic_arn
          }
        }
      },
      {
        Effect = "Allow"
        Principal = {
          Aws = module.iam_role.role.arn
        },
        Action = [
          "sqs:ChangeMessageVisibility",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"
        ],
        Resource = module.sqs_queue.queue_arn,
      }
    ]
  })
}

module "subscription" {
  source     = "git::https://github.com/barrydunne/Terraform.git//aws/sqs_sns_subscription"
  topic_arn  = var.subscription_topic_arn
  queue_arn  = module.sqs_queue.queue_arn
  depends_on = [module.lambda_function]
}
