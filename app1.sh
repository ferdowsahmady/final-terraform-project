#!/bin/bash
echo "Starting app1"
sudo yum update -y
sudo yum install -y httpd
sudo yum install -y stress
sudo yum install -y htop
sudo mkdir /var/www/html/app1
aws s3 cp s3://ferro-app1/index.html /var/www/html/app1/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
# sudo yum install -y aws-cli
# sudo yum install -y ruby
