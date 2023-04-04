resource "aws_iam_role" "lambda_role" {
  name               = "iac-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  lifecycle {
    ignore_changes = [
      assume_role_policy,
    ]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name_prefix = "iac-lambda-policy-"

  policy = data.aws_iam_policy_document.lambda_policy.json

  lifecycle {
    ignore_changes = [
      policy,
    ]
  }
}
