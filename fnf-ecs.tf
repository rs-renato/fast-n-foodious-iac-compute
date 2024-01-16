data "aws_caller_identity" "current" {}

# configuracao do cluster ECS
resource "aws_ecs_cluster" "fnf-cluster" {
    name = "fnf-cluster"
}


# configuracao produto service com Fargate
resource "aws_ecs_service" "fast-n-foodious-ms-produto-service" {
    name = "fast-n-foodious-ms-produto-service"
    task_definition = aws_ecs_task_definition.fnf-ms-produto-task-definition.arn
    launch_type = "FARGATE"
    cluster = aws_ecs_cluster.fnf-cluster.id
    desired_count = 1
    
    network_configuration {
      assign_public_ip = false
      security_groups = [
        data.terraform_remote_state.network.outputs.fnf-cluster-security-group_id
      ]
      subnets = [
        data.terraform_remote_state.network.outputs.fnf-subnet-private1-us-east-1a_id, 
        data.terraform_remote_state.network.outputs.fnf-subnet-private2-us-east-1b_id
      ]
    }

    load_balancer {
      target_group_arn = data.terraform_remote_state.network.outputs.fnf-lb-ms-produto-target-group_arn
      container_name = "fast-n-foodious-ms-produto"
      container_port = 3000
    }

    depends_on = [ 
        aws_ecs_task_definition.fnf-ms-produto-task-definition,
    ]

    lifecycle {
      create_before_destroy = true
      ignore_changes        = [task_definition]
    }
}

# configuracao pagamento service com Fargate
resource "aws_ecs_service" "fast-n-foodious-ms-pagamento-service" {
    name = "fast-n-foodious-ms-pagamento-service"
    task_definition = aws_ecs_task_definition.fnf-ms-pagamento-task-definition.arn
    launch_type = "FARGATE"
    cluster = aws_ecs_cluster.fnf-cluster.id
    desired_count = 1
    
    network_configuration {
      assign_public_ip = false
      security_groups = [
        data.terraform_remote_state.network.outputs.fnf-cluster-security-group_id
      ]
      subnets = [
        data.terraform_remote_state.network.outputs.fnf-subnet-private1-us-east-1a_id, 
        data.terraform_remote_state.network.outputs.fnf-subnet-private2-us-east-1b_id
      ]
    }

    load_balancer {
      target_group_arn = data.terraform_remote_state.network.outputs.fnf-lb-ms-pagamento-target-group_arn
      container_name = "fast-n-foodious-ms-pagamento"
      container_port = 3000
    }


    depends_on = [ 
        aws_ecs_task_definition.fnf-ms-pagamento-task-definition,
    ]

    lifecycle {
      create_before_destroy = true
      ignore_changes        = [task_definition]
    }
}

# configuracao pedido service com Fargate
resource "aws_ecs_service" "fast-n-foodious-ms-pedido-service" {
    name = "fast-n-foodious-ms-pedido-service"
    task_definition = aws_ecs_task_definition.fnf-ms-pedido-task-definition.arn
    launch_type = "FARGATE"
    cluster = aws_ecs_cluster.fnf-cluster.id
    desired_count = 1
    
    network_configuration {
      assign_public_ip = false
      security_groups = [
        data.terraform_remote_state.network.outputs.fnf-cluster-security-group_id
      ]
      subnets = [
        data.terraform_remote_state.network.outputs.fnf-subnet-private1-us-east-1a_id, 
        data.terraform_remote_state.network.outputs.fnf-subnet-private2-us-east-1b_id
      ]
    }

    load_balancer {
      target_group_arn = data.terraform_remote_state.network.outputs.fnf-lb-ms-pedido-target-group_arn
      container_name = "fast-n-foodious-ms-pedido"
      container_port = 3000
    }


    depends_on = [ 
        aws_ecs_task_definition.fnf-ms-pedido-task-definition,
    ]

    lifecycle {
      create_before_destroy = true
      ignore_changes        = [task_definition]
    }
}

# configuracao das tasks definitions para deploy do container produto
resource "aws_ecs_task_definition" "fnf-ms-produto-task-definition" {
  family                   = "fnf-ms-produto-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = 256
  memory = 512
  task_role_arn = aws_iam_role.ecs_instance_role.arn
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }
  depends_on = [ aws_iam_role.ecsTaskExecutionRole ]

  container_definitions = <<EOF
  [
    {
      "name": "fast-n-foodious-ms-produto",
      "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/fast-n-foodious-ms-produto:latest",
      "cpu": 256,
      "memory": 512,
      "memoryReservation": 512,
      "portMappings": [
        {
          "name": "fast-n-foodious-ms-produto-3000-tcp",
          "containerPort": 3000,
          "hostPort": 3000,
          "protocol": "TCP",
          "appProtocol": "http"
        }
      ],
      "essential": true,
      "environment": [
        {
          "name": "NODE_ENV",
          "value": "prod"
        },
        {
          "name": "MYSQL_HOST",
          "value": "${data.terraform_remote_state.storage.outputs.fnf-rds-cluster_endpoint}"
        },
        {
          "name": "MYSQL_PASSWORD",
          "value": "${data.terraform_remote_state.storage.outputs.fnf-rds-cluster_master_password}"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "/ecs/fnf-ms-produto-task-definition",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  EOF
}

# configuracao das tasks definitions para deploy do container pagamento
resource "aws_ecs_task_definition" "fnf-ms-pagamento-task-definition" {
  family                   = "fnf-ms-pagamento-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = 256
  memory = 512
  task_role_arn = aws_iam_role.ecs_instance_role.arn
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }
  depends_on = [ aws_iam_role.ecsTaskExecutionRole ]

  container_definitions = <<EOF
  [
    {
      "name": "fast-n-foodious-ms-pagamento",
      "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/fast-n-foodious-ms-pagamento:latest",
      "cpu": 256,
      "memory": 512,
      "memoryReservation": 512,
      "portMappings": [
        {
          "name": "fast-n-foodious-ms-pagamento-3000-tcp",
          "containerPort": 3000,
          "hostPort": 3000,
          "protocol": "TCP",
          "appProtocol": "http"
        }
      ],
      "essential": true,
      "environment": [
        {
          "name": "MS_PEDIDO_INTEGRATION_URL",
          "value": "${data.terraform_remote_state.network.outputs.fnf-alb_dns_name}"
        },
        {
          "name": "NODE_ENV",
          "value": "prod"
        },
        {
          "name": "MYSQL_HOST",
          "value": "${data.terraform_remote_state.storage.outputs.fnf-rds-cluster_endpoint}"
        },
        {
          "name": "MYSQL_PASSWORD",
          "value": "${data.terraform_remote_state.storage.outputs.fnf-rds-cluster_master_password}"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "/ecs/fnf-ms-pagamento-task-definition",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  EOF
}

# configuracao das tasks definitions para deploy do container pedido
resource "aws_ecs_task_definition" "fnf-ms-pedido-task-definition" {
  family                   = "fnf-ms-pedido-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = 256
  memory = 512
  task_role_arn = aws_iam_role.ecs_instance_role.arn
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }
  depends_on = [ aws_iam_role.ecsTaskExecutionRole ]

  container_definitions = <<EOF
  [
    {
      "name": "fast-n-foodious-ms-pedido",
      "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/fast-n-foodious-ms-pedido:latest",
      "cpu": 256,
      "memory": 512,
      "memoryReservation": 512,
      "portMappings": [
        {
          "name": "fast-n-foodious-ms-pedido-3000-tcp",
          "containerPort": 3000,
          "hostPort": 3000,
          "protocol": "TCP",
          "appProtocol": "http"
        }
      ],
      "essential": true,
      "environment": [
        {
          "name": "MS_PRODUTO_INTEGRATION_URL",
          "value": "${data.terraform_remote_state.network.outputs.fnf-alb_dns_name}"
        },
        {
          "name": "MS_PAGAMENTO_INTEGRATION_URL",
          "value": "${data.terraform_remote_state.network.outputs.fnf-alb_dns_name}"
        },
        {
          "name": "NODE_ENV",
          "value": "prod"
        },
        {
          "name": "MYSQL_HOST",
          "value": "${data.terraform_remote_state.storage.outputs.fnf-rds-cluster_endpoint}"
        },
        {
          "name": "MYSQL_PASSWORD",
          "value": "${data.terraform_remote_state.storage.outputs.fnf-rds-cluster_master_password}"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "/ecs/fnf-ms-pedido-task-definition",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  EOF
}