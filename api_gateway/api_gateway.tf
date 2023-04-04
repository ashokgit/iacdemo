resource "aws_api_gateway_rest_api" "audio_transcription_api" {
  name        = "audio-transcription-api"
  description = "API Gateway for audio transcription Lambda function"
}

resource "aws_api_gateway_resource" "transcribe_resource" {
  rest_api_id = aws_api_gateway_rest_api.audio_transcription_api.id
  parent_id   = aws_api_gateway_rest_api.audio_transcription_api.root_resource_id
  path_part   = "transcribe"
}

resource "aws_api_gateway_method" "transcribe_method" {
  rest_api_id   = aws_api_gateway_rest_api.audio_transcription_api.id
  resource_id   = aws_api_gateway_resource.transcribe_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "transcribe_integration" {
  rest_api_id = aws_api_gateway_rest_api.transcribe.id
  resource_id = aws_api_gateway_resource.transcribe.id
  http_method = aws_api_gateway_method.transcribe.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.iam.aws_lambda_function.transcription.invoke_arn
}

resource "aws_api_gateway_deployment" "transcribe_deployment" {
  depends_on = [aws_api_gateway_integration.transcribe_integration]

  rest_api_id = aws_api_gateway_rest_api.audio_transcription_api.id
  stage_name  = "test"
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.transcription.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.audio_transcription_api.execution_arn}/*/*"
}
