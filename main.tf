provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "transcription" {
  function_name = "audio-transcription"
  handler       = "transcribe_audio.lambda_handler" # Update the handler property
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
