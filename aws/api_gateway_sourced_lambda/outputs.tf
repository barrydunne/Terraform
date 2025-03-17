output "function_arn" {
  value = module.lambda_function.function_arn
}

output "iam_role_arn" {
  value = module.iam_role.role.arn
}

output "iam_role_name" {
  value = module.iam_role.role.name
}

output "api_gateway_id" {
  value = module.lambda_source.api_gateway_id
}