resource "aws_lambda_function" "lambda" {
  function_name    = var.function_name
  handler          = var.handler
  runtime          = var.runtime
  architectures    = var.architectures
  memory_size      = var.memory_size
  timeout          = var.timeout
  role             = var.iam_role.arn
  filename         = var.zip_path
  source_code_hash = filebase64sha256(var.zip_path)

  environment {
    variables = local.environment_variables
  }

  tracing_config {
    mode = "PassThrough"
  }

  # Explicitly depend on the IAM role to ensure it is fully available
  depends_on = [var.iam_role]
}
