# configuracao de role IAM para o lambda
resource "aws_iam_role" "fnf-lambda-iam-role" {
  name = "fnf-lambda-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# configuracao de policy IAM para o lambda
resource "aws_iam_policy" "fnf-lambda-iam-policy" {
  name        = "fnf-lambda-iam-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = ["arn:aws:logs:*:*:*"]
    },
    {
      Effect = "Allow",
      "Action": [
          "apigateway:InvokeApi",
          "apigateway:InvokeResource",
          "apigateway:InvokeMethod",
          "cognito-idp:AdminInitiateAuth",
          "cognito-idp:AdminRespondToAuthChallenge",
          "cognito-idp:AdminUserGlobalSignOut"
      ],
      Resource = ["*"]
    }]
  })
}

# configuracao de permission para invocacao do lambda via api gateway
resource "aws_lambda_permission" "fnf-lambda-permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fnf-lambda-authorizer.function_name
  principal     = "apigateway.amazonaws.com"
}

# configuracao de role vs policy
resource "aws_iam_role_policy_attachment" "fnf-lambda-iam-policy-attachment" {
  policy_arn = aws_iam_policy.fnf-lambda-iam-policy.arn
  role = aws_iam_role.fnf-lambda-iam-role.name
}