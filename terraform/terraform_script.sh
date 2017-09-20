#! /bin/bash
backend_server_header="[backend-server]"

base_url="ubuntu@"
targets=`terraform show |  grep public_dns | awk '{print $3}'` 
public_ip=`terraform show |  grep -w '\bpublic_ip\b' | awk '{print $3}'` 

urls=()
echo '' > ../ansible/hosts
for target in $targets
do
    url="$base_url$target"
    echo $backend_server_header >> ../ansible/hosts
    echo $url >> ../ansible/hosts
done

ssh-add ~/.ssh/latest_jrich_key
echo $url
ansible-playbook -i ../ansible/hosts ../ansible/playbooks/setup.yml --private-key=~/.ssh/latest_jrich_key --ssh-common-args='-o ForwardAgent=yes'
ansible-playbook -i ../ansible/hosts ../ansible/playbooks/python_setup.yml --private-key=~/.ssh/latest_jrich_key --ssh-common-args='-o ForwardAgent=yes'
ansible-playbook -i ../ansible/hosts ../ansible/playbooks/postgres_setup.yml --private-key=~/.ssh/latest_jrich_key --ssh-common-args='-o ForwardAgent=yes'
ansible-playbook -i ../ansible/hosts ../ansible/playbooks/site.yml --private-key=~/.ssh/latest_jrich_key --ssh-common-args='-o ForwardAgent=yes'

ansible-playbook -i ../ansible/hosts ../ansible/playbooks/project_setup.yml --private-key=~/.ssh/latest_jrich_key --ssh-common-args='-o ForwardAgent=yes' --extra-vars="machine_ip=$public_ip"
ansible-playbook -i ../ansible/hosts ../ansible/playbooks/backend_setup.yml --private-key=~/.ssh/latest_jrich_key --ssh-common-args='-o ForwardAgent=yes' --extra-vars="machine_ip=$public_ip full_url=$url"
ansible-playbook -i ../ansible/hosts ../ansible/playbooks/nginx_setup.yml --private-key=~/.ssh/latest_jrich_key --ssh-common-args='-o ForwardAgent=yes' --extra-vars="machine_ip=$public_ip"
