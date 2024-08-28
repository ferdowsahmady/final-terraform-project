#!/bin/bash
yum -y update
yum install -y ruby
yum install -y aws-cli
cd /home/ec2-user
aws s3 cp s3://aws-codedeploy-us-east-1/latest/install . --region us-east-1
chmod +x ./install
./install auto

#codedeploy agent instruction found here: https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-linux.html
#Install the CodeDeploy agent for Amazon Linux or RHEL - AWS CodeDeploy
#Sign in to the instance, and run the following commands, one at a time. Running the command sudo yum update first is considered best practice when using yum to install packages, but you can skip it...