resource "aws_iam_role" "lambda_role" {
  name = "iac-lambda-role"
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

  tags = {
    Environment = "dev"
  }

  # Add ignore_changes block to ignore errors if the role already exists
  ignore_changes = ["name"]
}

resource "aws_iam_policy" "lambda_policy" {
  name_prefix = "lambda_policy_"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  # Add ignore_changes block to ignore errors if the policy already exists
  ignore_changes = ["name_prefix"]
}
