output "fnf-api-deployment_invoke_url" {
  value = aws_apigatewayv2_stage.fnf-api-deployment.invoke_url
}

output "fnf-anonymouns-user" {
  value = aws_cognito_user.fnf-anonymouns-user
  sensitive = true
}

output "fnf-anonymouns-user_user_username" {
  value = aws_cognito_user.fnf-anonymouns-user.username
  sensitive = true
}

output "fnf-anonymouns-user_user_password" {
  value = aws_cognito_user.fnf-anonymouns-user.password
  sensitive = true
}

output "fnf-domain_domain" {
  value = aws_cognito_user_pool_domain.fnf-domain.domain
}

output "fnf-user-pool_id" {
  value = aws_cognito_user_pool.fnf-user-pool.id
}
