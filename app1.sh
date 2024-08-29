#!/bin/bash

sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd.service
# sudo systemctl enable httpd.service
sudo echo "<h1> At $(hostname -f) </h1>" > /var/www/html/index.html

yum -y update
yum install -y ruby
yum install -y aws-cli
cd /home/ec2-user
aws s3 cp s3://aws-codedeploy-us-east-1/latest/install . --region us-east-1
chmod +x ./install
./install auto