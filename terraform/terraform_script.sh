#! /bin/bash
#backend_server_header="[backend-server]"

#base_url="ubuntu@"
#targets=`terraform show |  grep public_dns | awk '{print $3}'` 
#urls=()
#for target in $targets
#do
#    url="$base_url$target"
#    echo $backend_server_header >> ../ansible/hosts
#    echo $url >> ../ansible/hosts
#done
#terraform show | grep public_dns;cat ../ansible/hosts

ssh-add ~/.ssh/latest_jrich_key

ansible-playbook -i ../ansible/hosts ../ansible/playbooks/setup.yml --private-key=~/.ssh/latest_jrich_key --ssh-common-args='-o ForwardAgent=yes' --become
ansible-playbook -i ../ansible/hosts ../ansible/playbooks/site.yml --private-key=~/.ssh/latest_jrich_key --ssh-common-args='-o ForwardAgent=yes'
ansible-playbook -i ../ansible/hosts ../ansible/playbooks/project_setup.yml --private-key=~/.ssh/latest_jrich_key --ssh-common-args='-o ForwardAgent=yes'
ansible-playbook -i ../ansible/hosts ../ansible/playbooks/backend_setup.yml --private-key=~/.ssh/latest_jrich_key --ssh-common-args='-o ForwardAgent=yes'
ansible-playbook -i ../ansible/hosts ../ansible/playbooks/nginx_setup.yml --private-key=~/.ssh/latest_jrich_key --ssh-common-args='-o ForwardAgent=yes' --become
