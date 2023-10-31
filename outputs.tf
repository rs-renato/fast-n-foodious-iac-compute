output "aws_cognito_user_fnf-anonymouns-user_username" {
  value = aws_cognito_user.fnf-anonymouns-user.username
}

output "aws_cognito_user_fnf-anonymouns-user_password" {
  value = aws_cognito_user.fnf-anonymouns-user.password
  sensitive = true
}

output "aws_apigatewayv2_stage_fnf-api-deployment_invoke_url" {
  value = aws_apigatewayv2_stage.fnf-api-deployment.invoke_url
}

output "aws_cognito_user_pool_domain_fnf-domain_domain" {
  value = aws_cognito_user_pool_domain.fnf-domain.domain
}

output "aws_cognito_user_pool_fnf-user-pool_id" {
  value = aws_cognito_user_pool.fnf-user-pool.id
}