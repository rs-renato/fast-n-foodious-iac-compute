# configuracao api gateway
resource "aws_apigatewayv2_api" "fnf-api" {
  name = "fnf-api"
  protocol_type = "HTTP"
}

# integracao gateway (produto) com o vpc link 
resource "aws_apigatewayv2_integration" "fnf-api-integration-produto" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  integration_type = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri = data.terraform_remote_state.network.outputs.fnf-alb-http-listener_arn
  connection_type = "VPC_LINK"
  connection_id = aws_apigatewayv2_vpc_link.fnf-vpc-link.id
}

# integracao gateway (pagamento) com o vpc link 
resource "aws_apigatewayv2_integration" "fnf-api-integration-pagamento" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  integration_type = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri = data.terraform_remote_state.network.outputs.fnf-alb-http-listener_arn
  connection_type = "VPC_LINK"
  connection_id = aws_apigatewayv2_vpc_link.fnf-vpc-link.id
}

# integracao gateway (pedido) com o vpc link 
resource "aws_apigatewayv2_integration" "fnf-api-integration-pedido" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  integration_type = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri = data.terraform_remote_state.network.outputs.fnf-alb-http-listener_arn
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

# integracao api gateway com o lambda create user, na rota DELETE v2/cliente
resource "aws_apigatewayv2_integration" "fnf-api-integration-delete-user" {
  api_id           = aws_apigatewayv2_api.fnf-api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.fnf-lambda-delete-user.arn
  integration_method = "DELETE" 
  passthrough_behavior = "WHEN_NO_MATCH"
  depends_on = [ aws_lambda_function.fnf-lambda-delete-user ]
}

# rota para todas os paths produto, com autenticacao/autorizacao JWT via Cognito
resource "aws_apigatewayv2_route" "fnf-api-produto-route" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  route_key = "ANY /v1/produto/{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.fnf-api-integration-produto.id}"
  authorizer_id = aws_apigatewayv2_authorizer.fnf-api-authorizer.id
  depends_on = [ aws_apigatewayv2_authorizer.fnf-api-authorizer ]
  authorization_type = "JWT"
}

# rota para todas os paths categoria, com autenticacao/autorizacao JWT via Cognito
resource "aws_apigatewayv2_route" "fnf-api-categoria-route" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  route_key = "ANY /v1/categoria/{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.fnf-api-integration-produto.id}"
  authorizer_id = aws_apigatewayv2_authorizer.fnf-api-authorizer.id
  depends_on = [ aws_apigatewayv2_authorizer.fnf-api-authorizer ]
  authorization_type = "JWT"
}

# rota para todas os paths pagamento, com autenticacao/autorizacao JWT via Cognito
resource "aws_apigatewayv2_route" "fnf-api-pagamento-route" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  route_key = "ANY /v1/pagamento/{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.fnf-api-integration-pagamento.id}"
  authorizer_id = aws_apigatewayv2_authorizer.fnf-api-authorizer.id
  depends_on = [ aws_apigatewayv2_authorizer.fnf-api-authorizer ]
  authorization_type = "JWT"
}

# rota para todas os paths pedido, com autenticacao/autorizacao JWT via Cognito
resource "aws_apigatewayv2_route" "fnf-api-pedido-route" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  route_key = "ANY /v1/pedido/{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.fnf-api-integration-pedido.id}"
  authorizer_id = aws_apigatewayv2_authorizer.fnf-api-authorizer.id
  depends_on = [ aws_apigatewayv2_authorizer.fnf-api-authorizer ]
  authorization_type = "JWT"
}

# rota para todas os paths item, com autenticacao/autorizacao JWT via Cognito
resource "aws_apigatewayv2_route" "fnf-api-item-route" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  route_key = "ANY /v1/item/{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.fnf-api-integration-pedido.id}"
  authorizer_id = aws_apigatewayv2_authorizer.fnf-api-authorizer.id
  depends_on = [ aws_apigatewayv2_authorizer.fnf-api-authorizer ]
  authorization_type = "JWT"
}

# rota para todas os paths cliente, com autenticacao/autorizacao JWT via Cognito
resource "aws_apigatewayv2_route" "fnf-api-cliente-route" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  route_key = "ANY /v1/cliente/{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.fnf-api-integration-pedido.id}"
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

# rota criação de user, em POST v2/cliente
resource "aws_apigatewayv2_route" "fnf-api-route-create-user" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  route_key = "POST /v2/cliente"
  target = "integrations/${aws_apigatewayv2_integration.fnf-api-integration-create-user.id}"
  authorizer_id = aws_apigatewayv2_authorizer.fnf-api-authorizer.id
  depends_on = [ aws_apigatewayv2_authorizer.fnf-api-authorizer ]
  authorization_type = "JWT"
}

# rota deleção de user, em DELETE v2/cliente
resource "aws_apigatewayv2_route" "fnf-api-route-delete-user" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  route_key = "DELETE /v2/cliente"
  target = "integrations/${aws_apigatewayv2_integration.fnf-api-integration-delete-user.id}"
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
