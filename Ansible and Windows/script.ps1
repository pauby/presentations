# Let's run through the code
rm ls /mnt/c/psconfeu2022

# Set the correct directory first
cd Ansible\ and\ Windows

. cred-secret.sh

cd ansible

# Update the hosts file with IP address
ansible -m win_ping psconfeu2022 -i hosts -e "ansible_user=$username ansible_password=$pwd"

# Copy the module - normally you'd use the ansible-galaxy command
/usr/bin/cp ../../../ansible_collection_pauby.psconfeu2022/. ~/.ansible/collections/ansible_collections/pauby/psconfeu2022/ -r -f

# Execute the playbook
ansible-playbook playbook.yml -i hosts -e "ansible_user=$username ansible_password=$pwd"
ansible-playbook playbook.yml -i hosts -e "ansible_user=$username ansible_password=$pwd"

ls /mnt/c/psconfeu2022

# Execute the playbook
ansible-playbook playbook.yml -i hosts -e "ansible_user=$username ansible_password=$pwd"
ansible-playbook playbook.yml -i hosts -e "ansible_user=$username ansible_password=$pwd"

ls /mnt/c/psconfeu2022