# Criando a role ECS Task Execution
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# resource "aws_iam_role" "ecsTaskRole" {
#   name = "ecsTaskRole"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect = "Allow",
#       Principal = {
#         Service = "ecs-tasks.amazonaws.com"
#       },
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

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
          "cognito-idp:AdminUserGlobalSignOut",
          "cognito-idp:AdminCreateUser",
          "cognito-idp:AdminSetUserPassword",
          "lambda:InvokeFunction"
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

# configuracao de permission para invocacao do lambda via cognito
resource "aws_lambda_permission" "fnf-lambda-permission-cognito" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fnf-lambda-authorizer.function_name
  principal     = "cognito-idp.amazonaws.com"
}

# configuracao de permission para invocacao do lambda via api gateway
resource "aws_lambda_permission" "fnf-lambda-pre-auth-permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fnf-lambda-pre-token-authorizer.function_name
  principal     = "apigateway.amazonaws.com"
}

# configuracao de permission para invocacao do lambda via api gateway
resource "aws_lambda_permission" "fnf-lambda-pre-auth-permission-cognito" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fnf-lambda-pre-token-authorizer.function_name
  principal     = "cognito-idp.amazonaws.com"
}

# configuracao de permission para invocacao do lambda via api gateway
resource "aws_lambda_permission" "fnf-lambda-create-user-permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fnf-lambda-create-user.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "fnf-lambda-create-user-permission-cognito" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fnf-lambda-create-user.function_name
  principal     = "cognito-idp.amazonaws.com"
}

resource "aws_lambda_permission" "fnf-lambda-pre-signup-permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fnf-lambda-pre-signup.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "fnf-lambda-pre-signup-permission-cognito" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fnf-lambda-pre-signup.function_name
  principal     = "cognito-idp.amazonaws.com"
}

# configuracao de role vs policy
resource "aws_iam_role_policy_attachment" "fnf-lambda-iam-policy-attachment" {
  policy_arn = aws_iam_policy.fnf-lambda-iam-policy.arn
  role = aws_iam_role.fnf-lambda-iam-role.name
}

resource "aws_iam_policy_attachment" "ecsTaskExecutionRolePolicyAttachment" {
  name       = "AmazonECSTaskExecutionRolePolicyAttachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles      = [aws_iam_role.ecsTaskExecutionRole.name]
}


resource "aws_iam_policy_attachment" "ecsTaskExecutionRolePolicyAttachmentCloudWatch" {
  name       = "AmazonECSTaskExecutionRolePolicyAttachment"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  roles      = [aws_iam_role.ecsTaskExecutionRole.name]
}