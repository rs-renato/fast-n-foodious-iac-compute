# configuracao do loadbalancer
resource "aws_alb" "fnf-alb" {
    name = "fnf-alb"
    internal = true
    load_balancer_type =  "application"

    subnets = [ 
        aws_subnet.fnf-subnet-private1-us-east-1a.id,
        aws_subnet.fnf-subnet-private2-us-east-1b.id
    ]
    
    security_groups = [ 
        aws_security_group.fnf-lb-security-group.id
    ]

    depends_on = [ aws_internet_gateway.fnf-igw ]
}

# configuracao de listener http 
resource "aws_lb_listener" "fnf-alb-http" {
    load_balancer_arn = aws_alb.fnf-alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.fnf-lb-target-group.arn
    }
}

# configuracao de target group do loadbalancer
resource "aws_lb_target_group" "fnf-lb-target-group" {
    name = "fnf-lb-target-group"
    port = 3000
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = aws_vpc.fnf-vpc.id
    
    health_check {
      enabled = true
      path = "/health"
    }

    depends_on = [ aws_alb.fnf-alb ]
}