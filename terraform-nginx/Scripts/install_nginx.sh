#!/bin/bash
yum update -y
yum install nginx -y
yum nginx -v
echo "This instance is: $(hostname)" > /var/www/html/index.html
systemctl start nginx
systemctl enable nginx