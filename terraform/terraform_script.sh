#! /bin/bash
#echo '[celery-server]' > ../ansible/hosts

#aws_url="ubuntu@"
#url="$aws_url`terraform show | grep public_dns | awk '{print $3}'`"
#echo $url > ../ansible/hosts

ansible -i ../ansible/ex_hosts all -a "mkdir /opt/backend_api" --private-key=~/.ssh/latest_joseph_key --sudo
