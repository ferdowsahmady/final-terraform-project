resource "aws_sns_topic" "cpu_alert" {
  name = "project-app-cpu-usage-alert"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "app1-high-cpu-usage-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors ec2 app1 cpu utilization"
  alarm_actions       = [aws_sns_topic.cpu_alert.arn]

  dimensions = {
    AutoScalingGroupName =  aws_autoscaling_group.app1_asg.name
  }
}

resource "aws_sns_topic_subscription" "cpu_alert_sms" {
  topic_arn = aws_sns_topic.cpu_alert.arn
  endpoint_auto_confirms          = true
  protocol  = "sms"
  endpoint  = "+19254887668"
}

resource "aws_sns_topic_subscription" "cpu_alert_email" {
  topic_arn = aws_sns_topic.cpu_alert.arn
  protocol  = "email"
  endpoint  = "ferdowsahmady@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm2" {
  alarm_name          = "app2-high-cpu-usage-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"
  alarm_description   = "This metric monitors ec2 app2 cpu utilization"
  alarm_actions       = [aws_sns_topic.cpu_alert.arn]

  dimensions = {
    AutoScalingGroupName =  aws_autoscaling_group.app2_asg.name
  }
}