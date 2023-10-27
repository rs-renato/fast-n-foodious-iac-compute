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