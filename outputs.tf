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

output "fnf_sqs_solicitar_pagamento_req_id" {
  value = aws_sqs_queue.fnf-solicitar-pagamento-req.id
}

output "fnf_sqs_preparacao_pedido_req_id" {
  value = aws_sqs_queue.fnf-preparacao-pedido-req.id
}

output "fnf_sqs_webhook_pagamento_rejeitado_res_id" {
  value = aws_sqs_queue.fnf-webhook-pagamento-rejeitado-res.id
}

output "fnf_sqs_webhook_pagamento_confirmado_res_id" {
  value = aws_sqs_queue.fnf-webhook-pagamento-confirmado-res.id
}

output "fnf_sqs_dlq_fifo_id" {
  value = aws_sqs_queue.fnf-sqs-dlq-fifo.id
}

output "fnf_sqs_dlq_id" {
  value = aws_sqs_queue.fnf-sqs-dlq.id
}