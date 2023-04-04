terraform {
  required_version = ">= 0.14"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "transcription" {
  function_name = "audio-transcription"
  handler       = "transcribe_audio.transcribe_audio"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_role.arn

  filename = "./lambda_function/lambda_function.zip"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.transcription.function_name
  principal     = "apigateway.amazonaws.com"
}

module "iam" {
  source = "./iam"
}

module "api_gateway" {
  source = "./api_gateway"
}