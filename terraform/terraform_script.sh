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
terraform show | grep public_dns;cat ../ansible/hosts

ansible-playbook -i ../ansible/hosts ../ansible/playbooks/setup.yml --private-key=~/.ssh/latest_joseph_key --ssh-common-args='-o ForwardAgent=yes' --sudo
#before can call git need to add ssh key to identity when passing ssh agent add the private key to agent by ssh-add ~/.ssh/key_to_add
ssh-add ~/.ssh/latest_joseph_key
ansible-playbook -i ../ansible/hosts ../ansible/playbooks/site.yml --private-key=~/.ssh/latest_joseph_key --ssh-common-args='-o ForwardAgent=yes'
#url="$aws_url`terraform show | grep public_dns | awk '{print $3}'`"
#echo $url > ../ansible/hosts
#ssh -i ~/.ssh/latest_joseph_key ubuntu@ec2-52-38-206-242.us-west-2.compute.amazonaws.com
#ansible -i ../ansible/ex_hosts all -a "mkdir /opt/backend_api" --private-key=~/.ssh/latest_joseph_key --sudo
