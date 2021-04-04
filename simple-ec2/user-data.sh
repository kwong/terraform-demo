#! /bin/bash

# get latest update
yum update -y
yum upgrade -y

# Configure Cloudwatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm

# Use cloudwatch config from SSM
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c ssm:${ssm_cw_config} \
-s

# install apache
yum install httpd -y

echo "hello world!" > /var/www/html/index.html

systemctl start httpd.service

echo 'completed'

