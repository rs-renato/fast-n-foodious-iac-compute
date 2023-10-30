![Static Badge](https://img.shields.io/badge/cloud-black?style=for-the-badge) ![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)

![Static Badge](https://img.shields.io/badge/IaC-black?style=for-the-badge) ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

# 🍔 Fast & Foodious - IaC ![Static Badge](https://img.shields.io/badge/v3.0.0-version?logo=&color=%232496ED&labelColor=white&label=fast-n-foodious)
Sistema de auto-atendimento de fast food. Projeto de conclusão da Fase 03 da pós gradução em Software Architecture.

![fast-n-foodious-aws](fast-n-foodious-aws.png)


## Módulo IaC: Compute
Repositório de criação de infraestrutura cloud AWS, responsável por criar os seguintes recursos:

```
fast-n-foodious-iac-compute
├── fnf-api-gateway.tf                          # Definição de recurso API Gateway, com registro de rotas e controle de acesso de recursos
├── fnf-cognito.tf                              # Definição de recurso Cognito, para registro de usuários destinados a controle de acesso, autenticação e autorização
├── fnf-ecs.tf                                  # Definição de recurso cluster ECS gerenciado com Fargate
├── fnf-iam.tf                                  # Definição de recursos Roles, polices e permissões
├── fnf-lambda-authorizer.js                    # Lambda destinado a autorização de acesso aos recursos da API
├── fnf-lambda-axios-layer.zip                  # Layer axios, utilizada como dependância lambda
├── fnf-lambda-create-user.js                   # Lambda destinada a criação de novos usuários no Cognito
├── fnf-lambda-pre-signup.js                    # Lambda utilizada como trigger do evento Cognito (Pre Sign-Up), responsável por cadatrar novos clientes
├── fnf-lambda-pre-token-authorizer.js          # Lambda utilizada como trigger do evento Cognito (Pre Token Generation), responsável por sobrescrever claims jwt
├── fnf-lambda.tf                               # Definição de recursos Lambdas
├── main.tf                                     # Definição de terraform providers e backend 
├── outputs.tf                                  # Definição de terraform outputs, necessários em módulos externos
└── remote.state.tf                             # Definição de terraform remote state, necessário no módulo local
```