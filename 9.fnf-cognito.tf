resource "aws_cognito_user_pool" "fnf-user-pool" {
    name = "fnf-user-pool"
    username_attributes        = ["email", "phone_number"]
    auto_verified_attributes  = ["email"]

    account_recovery_setting {
      recovery_mechanism {
        priority = 1
        name = "verified_email"
      }
    }
    password_policy {
        minimum_length    = 8
        require_lowercase = true
        require_numbers   = true
        require_symbols   = true
        require_uppercase = true
    }
}

resource "aws_cognito_user_pool_client" "fnf-client" {
  name                                  = "fnf-client"
  user_pool_id                          = aws_cognito_user_pool.fnf-user-pool.id
  allowed_oauth_scopes                  = ["fnf-resource-server/read", "fnf-resource-server/write"]
  allowed_oauth_flows                   = [ "client_credentials"]
  generate_secret                       = true
  explicit_auth_flows                   = ["ALLOW_USER_SRP_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  prevent_user_existence_errors         = "ENABLED"

  access_token_validity                 = 1
  id_token_validity                     = 1
  refresh_token_validity                = 30
  enable_token_revocation               = true
  allowed_oauth_flows_user_pool_client = true
  read_attributes                       = ["email"]
  supported_identity_providers = ["COGNITO"]
  depends_on = [ aws_cognito_resource_server.fnf-resource-server ]
}

resource "aws_cognito_resource_server" "fnf-resource-server" {
  user_pool_id       = aws_cognito_user_pool.fnf-user-pool.id
  identifier         = "fnf-resource-server"
  name               = "fnf-resource-server"
  scope {
    scope_name       = "read"
    scope_description= "Read access"
  }
  scope {
    scope_name       = "write"
    scope_description= "Write access"
  }
}

resource "aws_cognito_user_pool_domain" "fnf-domain" {
  domain        = "fast-n-foodious-${random_id.ramdom-domain-number.hex}"
  user_pool_id  = aws_cognito_user_pool.fnf-user-pool.id
}

resource "random_id" "ramdom-domain-number" {
  keepers = {
    first = "${timestamp()}"
  }     
  byte_length = 4
}

output "client_id" {
  value = aws_cognito_user_pool_client.fnf-client.id
}