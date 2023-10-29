# configuracao api gateway
resource "aws_apigatewayv2_api" "fnf-api" {
  name = "fnf-api"
  protocol_type = "HTTP"
}

# integracao gateway com o vpc link 
resource "aws_apigatewayv2_integration" "fnf-api-integration" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  integration_type = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri = data.terraform_remote_state.network.outputs.fnf-alb-http_arn
  connection_type = "VPC_LINK"
  connection_id = aws_apigatewayv2_vpc_link.fnf-vpc-link.id
}

# integracao api gateway com o lambda authorizer, na rota POST /oauth2/token
resource "aws_apigatewayv2_integration" "fnf-api-integration-oauth" {
  api_id           = aws_apigatewayv2_api.fnf-api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.fnf-lambda-authorizer.invoke_arn
  integration_method = "POST" 
  passthrough_behavior = "WHEN_NO_MATCH"
  depends_on = [ aws_lambda_function.fnf-lambda-authorizer ]
}

# integracao api gateway com o lambda create user, na rota POST v2/cliente
resource "aws_apigatewayv2_integration" "fnf-api-integration-create-user" {
  api_id           = aws_apigatewayv2_api.fnf-api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.fnf-lambda-create-user.arn
  integration_method = "POST" 
  passthrough_behavior = "WHEN_NO_MATCH"
  depends_on = [ aws_lambda_function.fnf-lambda-create-user ]
}

# rota para todas os paths, com autenticacao/autorizacao JWT via Cognito
resource "aws_apigatewayv2_route" "fnf-api-route" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  route_key = "ANY /{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.fnf-api-integration.id}"
  authorizer_id = aws_apigatewayv2_authorizer.fnf-api-authorizer.id
  depends_on = [ aws_apigatewayv2_authorizer.fnf-api-authorizer ]
  authorization_type = "JWT"
}

# rota de autenticacao via lambda, em POST oauth2/token 
resource "aws_apigatewayv2_route" "fnf-api-route-token" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  route_key = "POST /oauth2/token"
  target = "integrations/${aws_apigatewayv2_integration.fnf-api-integration-oauth.id}"
}

# rota ciarcao de user, em POST v2/cliente
resource "aws_apigatewayv2_route" "fnf-api-route-create-user" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  route_key = "POST /v2/cliente"
  target = "integrations/${aws_apigatewayv2_integration.fnf-api-integration-create-user.id}"
  authorizer_id = aws_apigatewayv2_authorizer.fnf-api-authorizer.id
  depends_on = [ aws_apigatewayv2_authorizer.fnf-api-authorizer ]
  authorization_type = "JWT"
}

# autorizer JWT via Cognito
resource "aws_apigatewayv2_authorizer" "fnf-api-authorizer" {
  api_id             = aws_apigatewayv2_api.fnf-api.id
  authorizer_type    = "JWT"
  identity_sources    = ["$request.header.Authorization"]
  name                = "fnf-authorizer"
  jwt_configuration {
    issuer = "https://${aws_cognito_user_pool.fnf-user-pool.endpoint}"
    audience = [aws_cognito_user_pool_client.fnf-client.id]
  }
}

# configuracao api gateway com o vpc link
resource "aws_apigatewayv2_vpc_link" "fnf-vpc-link" {
  name = "fnf-vpc-link"
  security_group_ids = [data.terraform_remote_state.network.outputs.fnf-lb-security-group_id]
  subnet_ids = [data.terraform_remote_state.network.outputs.fnf-subnet-private1-us-east-1a_id, data.terraform_remote_state.network.outputs.fnf-subnet-private2-us-east-1b_id]
}

# deployment do api gateway
resource "aws_apigatewayv2_stage" "fnf-api-deployment" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  name = "$default"
  auto_deploy = true
}

# output com a url do api gateway
output "fnf-api-url" {
  value = aws_apigatewayv2_stage.fnf-api-deployment.invoke_url
}
