# configuracao do cluster ECS
resource "aws_ecs_cluster" "fnf-cluster" {
    name = "fnf-cluster"
}

# configuracao service com Fargate
resource "aws_ecs_service" "fnf-service" {
    name = "fnf-service"
    task_definition = aws_ecs_task_definition.fnf-task-definition.arn
    launch_type = "FARGATE"
    cluster = aws_ecs_cluster.fnf-cluster.id
    desired_count = 2
    
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
      target_group_arn = data.terraform_remote_state.network.outputs.fnf-lb-target-group_arn
      container_name = "fast-n-foodious"
      container_port = 3000
    }

    depends_on = [ 
        aws_ecs_task_definition.fnf-task-definition,
    ]

    lifecycle {
      create_before_destroy = true
      ignore_changes        = [task_definition]
    }
}

# configuracao das tasks definitions para deploy do container 
resource "aws_ecs_task_definition" "fnf-task-definition" {
  family                   = "fnf-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = 512
  memory = 1024
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }
  depends_on = [ aws_iam_role.ecsTaskExecutionRole ]

  container_definitions = <<EOF
  [
    {
      "name": "fast-n-foodious",
      "image": "438194348765.dkr.ecr.us-east-1.amazonaws.com/fast-n-foodious:latest",
      "cpu": 512,
      "memory": 1024,
      "memoryReservation": 1024,
      "portMappings": [
        {
          "name": "fast-n-foodious-3000-tcp",
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
          "awslogs-group": "/ecs/fnf-task-definition",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  EOF
}
