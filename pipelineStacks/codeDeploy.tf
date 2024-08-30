resource "aws_iam_role" "deploy_role" {
  name = "app1-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codedeploy_policy" {
  name = "deploy_policy"
  role = aws_iam_role.deploy_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_codedeploy_app" "app1" {
  name = "app1Deploy"
}

resource "aws_codedeploy_deployment_group" "app1_deployment" {
  app_name              = aws_codedeploy_app.app1.name
  deployment_group_name = "app1DeploymentGroup"
  service_role_arn      = aws_iam_role.deploy_role.arn

  ec2_tag_filter {
    key   = "AnyKey"
    type  = "KEY_ONLY"
    value = ""
  }
}
