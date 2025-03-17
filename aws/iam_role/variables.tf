variable "role_name" {
  description = "The name of the IAM role to create or use."
  type        = string
}

variable "attach_policy_arn" {
  description = "The ARN of the policy to attach to the IAM role."
  type        = string
  default     = null
}

variable "inline_policy" {
  description = "The inline policy to attach to the IAM role."
  type        = string
  default     = null
}

variable "assume_role_policy" {
  description = "The assume role policy for the IAM role."
  type        = string
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": []
}
EOF
}