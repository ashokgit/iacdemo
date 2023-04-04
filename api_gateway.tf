resource "aws_api_gateway_rest_api" "transcription_api" {
  name        = "TranscriptionAPI"
  description = "API Gateway for audio transcription"
}

resource "aws_api_gateway_resource" "transcription_resource" {
  rest_api_id = aws_api_gateway_rest_api.transcription_api.id
  parent_id   = aws_api_gateway_rest_api.transcription_api.root_resource_id
  path_part   = "transcribe"
}

resource "aws_api_gateway_method" "transcription_method" {
  rest_api_id   = aws_api_gateway_rest_api.transcription_api.id
  resource_id   = aws_api_gateway_resource.transcription_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "transcription_integration" {
  rest_api_id = aws_api_gateway_rest_api.transcription_api.id
  resource_id = aws_api_gateway_resource.transcription_resource.id
  http_method = aws_api_gateway_method.transcription_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.transcription.invoke_arn
}

resource "aws_api_gateway_deployment" "transcription_deployment" {
  depends_on = [
    aws_api_gateway_integration.transcription_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.transcription_api.id
  stage_name  = "prod"
}

