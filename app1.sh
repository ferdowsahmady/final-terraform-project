#!/bin/bash
sudo mkdir -p /var/www/html/app1
sudo yum -y update
sudo yum install -y ruby
sudo yum install -y aws-cli
cd /home/ec2-user
aws s3 cp s3://aws-codedeploy-us-east-1/latest/install . --region us-east-1
sudo chmod +x ./install
sudo ./install auto

