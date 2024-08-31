# 026DO Terraform Final Project (Code-Killers)

This will create the following resources for 2x applications using AWS native CI/CD tools.

1x VPC and all required components 2x Launch Templates 
2x Autoscaling Groups
2x Dynamic Scaling Policies
2x SNS topics for notifications 
1x CloudWatch Metric Alarm for monitoring 
1x Application Load Balancer
2x Target Groups for LB 
1x LB Listener with following rules:
    - /path1/* -> app1-tg
    - /path2/* -> app2-tg

