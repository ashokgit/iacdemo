provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "transcription" {
  function_name = "audio-transcription"
  handler       = "transcribe_audio.transcribe_audio"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_role.arn

  filename = "lambda_function.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "example-lambda-role"

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

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "apigateway.amazonaws.com"
}