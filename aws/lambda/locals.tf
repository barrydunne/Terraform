locals {

  global_vars = {
    "ASPNETCORE_ENVIRONMENT"      = var.aspnetcore_environment
    "LAMBDA_VERSION"              = var.function_version
    "LAMBDA_NET_SERIALIZER_DEBUG" = "true"
  }

  local_vars = {
    "AWS_ACCESS_KEY_ID"         = "local"
    "AWS_SECRET_ACCESS"         = "local"
    "AWS_REGION"                = "eu-west-1"
    "AWS__Region"               = "eu-west-1"
    "Region"                    = "eu-west-1"
    "AuthenticationRegion"      = "eu-west-1"
    "AWS__AuthenticationRegion" = "eu-west-1"
    "ServiceURL"                = "http://host.docker.internal:4566"
    "AWS__ServiceURL"           = "http://host.docker.internal:4566"
  }

  environment_variables = data.aws_caller_identity.current.account_id == "000000000000" ? merge(var.environment_variables, local.global_vars, local.local_vars) : merge(var.environment_variables, local.global_vars)

}
