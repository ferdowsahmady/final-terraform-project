# app1 launch-template
resource "aws_launch_template" "app1" {
  name = "app1-launch-template"
  image_id = data.aws_ami.amazon_linux_2023.image_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = var.instance_type
  key_name = aws_key_pair.rsa-key-deployer.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
  
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 30
    }
  }
  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups   = var.vpc_security_group
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
    Name        =   "${var.environment}-app1-launch-template"
    Environment =   var.environment
    }
  }
  user_data = base64encode(file("../../app1.sh"))
}

# ASG-app1
resource "aws_autoscaling_group" "app1_asg" {
  name                 = "project-app1-asg"
  min_size             = 1
  max_size             = 3
  # desired_capacity     = 1
  force_delete         = true
  health_check_grace_period = 0
  vpc_zone_identifier  = var.asg_vpc_zone_identifier
  target_group_arns = [aws_lb_target_group.app1.arn]

  launch_template {
    id = aws_launch_template.app1.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.environment}-app1-instance"
    propagate_at_launch = true
  }
}

# ALB app1-tg
resource "aws_lb_target_group" "app1" {
  name     = "app1-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 10
    matcher             = "200-299"
  }
    
    tags = {
      Name        =   "${var.environment}-app1-tg"
      Environment =   var.environment
  }
}

#ASG/TG attachments 
resource "aws_autoscaling_attachment" "test1" {
  autoscaling_group_name = aws_autoscaling_group.app1_asg.id
  lb_target_group_arn    = aws_lb_target_group.app1.arn
}

#LB-Listener rule app1
resource "aws_lb_listener_rule" "app1-rule" {
  listener_arn = aws_lb_listener.web.arn
  priority     = 100

  action {
    type               = "forward"
    target_group_arn   = aws_lb_target_group.app1.arn
  }

  condition {
    path_pattern {
      values = ["/app1/*"]
    }
  }
}

#Dynamic Scaling Policy
resource "aws_autoscaling_policy" "project-asg-policy" {
  name                   = "project-asg-dynamic-policy"
  policy_type            = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.app1_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 30.0
    disable_scale_in = false
  }
}

