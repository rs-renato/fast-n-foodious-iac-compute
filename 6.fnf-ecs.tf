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
        aws_security_group.fnf-cluster-security-group.id
      ]
      subnets = [
        aws_subnet.fnf-subnet-private1-us-east-1a.id, 
        aws_subnet.fnf-subnet-private2-us-east-1b.id
      ]
    }

    load_balancer {
      target_group_arn = aws_lb_target_group.fnf-lb-target-group.arn
      container_name = "fast-n-foodious"
      container_port = 3000
    }

    depends_on = [ 
        aws_ecs_task_definition.fnf-task-definition,
        aws_alb.fnf-alb
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
  execution_role_arn = "arn:aws:iam::438194348765:role/ecsTaskExecutionRole"
  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }

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
          "appProtocol": "HTTP"
        }
      ],
      "essential": true,
      "environment": [
        {
          "name": "NODE_ENV",
          "value": "local-mock-repository"
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
