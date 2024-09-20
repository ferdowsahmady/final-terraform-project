#Application Load Balancer
resource "aws_lb" "project_alb" {
  name               = "project-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.vpc_security_group  
  subnets            = var.alb-subnets

  enable_deletion_protection = false
  
    tags = {
    Name        =   "${var.environment}-project-alb"
    Environment =   var.environment
  }
}

#ALB-Listener
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.project_alb.arn
  port              = "80"
  protocol          = "HTTP"

 default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "default listener"
      status_code  = "200"
    }
  }
}