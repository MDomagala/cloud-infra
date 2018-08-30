#!/bin/bash
apt-get update
apt-get install python-pip -y
pip install awscli --upgrade --user
aws s3 cp s3://me-and-myself-s3-bucket/index.html /home/ubuntu/index.html