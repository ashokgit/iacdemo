resource "aws_iam_role" "lambda_role" {
  count = var.create_iam_resources ? 1 : 0
  name = var.lambda_role_name
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
  # ignore_changes = ["name"]
}

data "aws_iam_role" "existing_lambda_role" {
  count = var.create_iam_resources ? 0 : 1
  name  = var.lambda_role_name
}

resource "aws_iam_policy" "lambda_policy" {
  count = var.create_iam_resources ? 1 : 0
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
  # ignore_changes = ["name_prefix"]
}

data "aws_iam_policy" "existing_lambda_policy" {
  count = var.create_iam_resources ? 0 : 1
  name_prefix  = "lambda_policy_"
}
