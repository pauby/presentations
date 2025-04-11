# Set the correct directory first
source cred-secret.sh
cd ansible
export ANSIBLE_HOST_KEY_CHECKING=False
clear

# Update the hosts file with IP address
ansible -m win_ping demo_host -i hosts -e "ansible_user=$username ansible_password=$pwd"
ansible -m win_ping -a "data='DEMO'" demo_host -i hosts -e "ansible_user=$username ansible_password=$pwd"
ansible -m win_ping -a "data='crash'" demo_host -i hosts -e "ansible_user=$username ansible_password=$pwd"

# Copy the module - normally you'd use the ansible-galaxy command
mkdir -p ~/.ansible/collections/ansible_collections/pauby/myfirstwinmodule/
cp ../pauby.myfirstwinmodule/. ~/.ansible/collections/ansible_collections/pauby/myfirstwinmodule/ -r -f

# Check VM for the folder and file

# Execute the playbook
# absent
ansible-playbook playbook.yml -i hosts -e "ansible_user=$username ansible_password=$pwd"
# present
ansible-playbook playbook.yml -i hosts -e "ansible_user=$username ansible_password=$pwd"

# Execute the playbook
# present - show that the changed=0
ansible-playbook playbook.yml -i hosts -e "ansible_user=$username ansible_password=$pwd"
# absent - show that the file is gone again
ansible-playbook playbook.yml -i hosts -e "ansible_user=$username ansible_password=$pwd"