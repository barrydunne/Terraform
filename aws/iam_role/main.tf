resource "aws_iam_role" "iam_role" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count      = var.attach_policy_arn != null ? 1 : 0
  role       = var.role_name
  policy_arn = var.attach_policy_arn
  # Explicitly depend on the IAM role to ensure it is fully available
  depends_on = [aws_iam_role.iam_role]
}

resource "aws_iam_role_policy" "inline_policy_attachment" {
  count  = var.inline_policy != null ? 1 : 0
  role   = var.role_name
  policy = var.inline_policy
  # Explicitly depend on the IAM role to ensure it is fully available
  depends_on = [aws_iam_role.iam_role]
}