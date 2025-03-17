module "iam_role" {
  source            = "git::https://github.com/barrydunne/Terraform.git//aws/iam_role"
  role_name         = "${var.function_name}-role"
  attach_policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
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
  source           = "git::https://github.com/barrydunne/Terraform.git//aws/lambda"
  environment      = var.environment
  function_name    = var.function_name
  function_version = var.function_version
  handler          = var.function_handler
  runtime          = var.function_runtime
  architectures    = var.function_architectures
  memory_size      = var.function_memory_size
  timeout          = var.function_timeout
  zip_path         = var.function_zip_path
  iam_role         = module.iam_role.role
  environment_variables = {
    ASPNETCORE_ENVIRONMENT      = var.aspnetcore_environment
    LAMBDA_VERSION              = var.function_version
    LAMBDA_NET_SERIALIZER_DEBUG = "true"
  }

  depends_on = [module.iam_role]
}

module "lambda_source" {
  source              = "git::https://github.com/barrydunne/Terraform.git//aws/lambda_source_api_gateway_websocket"
  function_name       = var.function_name
  function_invoke_arn = module.lambda_function.invoke_arn
  api_gateway_path    = var.api_gateway_path

  depends_on = [module.lambda_function]
}
