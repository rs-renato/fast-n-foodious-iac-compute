# Criação de usuário 'tf-user' Terraform manualmente
- IAM > User > Create User
- Marcar a opção Provide user access to the AWS Management Console  e desmarcar Users must create a new password at next sign-in - Recommended
- Selecionar Attach policies directly e adicionar a role AdministratorAccess
- Criar access key para o usuário
- regitrar o accesskey do usuário tf-user no ~/.aws/credentials

# Modificar a AWS Account no arquivo fnf-ecs.tf

Substituir o placeholder `<<account_id>>` pelo valor da sua conta AWS nas linhas:
execution_role_arn = "arn:aws:iam::`<<account_id>>`:role/ecsTaskExecutionRole"
image = "`<<account_id>>`.dkr.ecr.us-east-1.amazonaws.com/fast-n-foodious:latest",

# Criar o ECR repo fast-n-foodious

- Amazon ECR > Repositories > Create repository
- Repository name: fast-n-foodious

# Criar role ecsTaskExecutionRole

- IAM > Roles > Create role
- Trusted entity: AWS service 
- Use case: Elastic Container Service
  - Marcar Elastic Container Service Task
- Permissions Policies:
  - AmazonECSTaskExecutionRolePolicy
  - CloudWatchLogsFullAccess
- Name: ecsTaskExecutionRole
- Trust policy: the default one
  ```
    {
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": {
                    "Service": [
                        "ecs-tasks.amazonaws.com"
                    ]
                },
                "Sid": ""
            }
        ],
        "Version": "2012-10-17"
    }
  ```


# Instalar Terraform e inicializar terraform
- https://developer.hashicorp.com/terraform/downloads?product_intent=terraform
- $ terraform init
- $ terraform plan
- $ terraform apply



## Referencia
https://section411.com/2019/07/hello-world