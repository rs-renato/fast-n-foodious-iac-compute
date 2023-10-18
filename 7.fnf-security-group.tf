// configuracao de security group do loadbalancer
resource "aws_security_group" "fnf-lb-security-group" {
  name        = "fnf-lb-security-group"
  description = "Allow API Gateway to connect to ECS"
  vpc_id      = aws_vpc.fnf-vpc.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    description = "Allow all outbound traffic"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// configuracao de security group do cluster
resource "aws_security_group" "fnf-cluster-security-group" {
  name        = "fnf-cluster-security-group"
  description = "Allow traffic from fnf-lb-security-group on port 3000"
  vpc_id      = aws_vpc.fnf-vpc.id
  
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "TCP"
    security_groups = [aws_security_group.fnf-lb-security-group.id]
  }
  
  egress {
    description = "Allow all outbound traffic"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}