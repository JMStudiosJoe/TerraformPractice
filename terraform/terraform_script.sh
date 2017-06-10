#! /bin/bash
celery_header="[celery-server]"
backend_server_header="[backend-server]"
echo $celery_header > ../ansible/hosts

base_url="ubuntu@"
targets=`terraform show |  grep public_dns | awk '{print $3}'` 
urls=()
for target in $targets
do
    url="$base_url$target"
    echo $url >> ../ansible/hosts
    echo $backend_server_header >> ../ansible/hosts
done


#url="$aws_url`terraform show | grep public_dns | awk '{print $3}'`"
#echo $url > ../ansible/hosts

#ansible -i ../ansible/ex_hosts all -a "mkdir /opt/backend_api" --private-key=~/.ssh/latest_joseph_key --sudo
