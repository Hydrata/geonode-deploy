set -x # Print commands and their arguments as they are executed.
exec > >(tee -i bootstrap.log)
exec 2>&1
echo starting bootstrap.sh

sudo apt update -y
sudo apt install software-properties-common -y
sudo apt install python-is-python3
sudo apt install python3-pip -y
sudo apt install make -y
sudo pip install ansible --quiet

# copy private key from host to VM and fix permissions.
sudo cp -a /opt/geonode-deploy/vagrant/include/my_key_name /home/vagrant/.ssh/
sudo chmod 600 /home/vagrant/.ssh/my_key_name

# add the public key to "authorized_keys" so that Ansible will allow ssh to localhost from the VM to the VM
sudo cp -a /opt/geonode-deploy/vagrant/include/my_key_name.pub /home/vagrant/.ssh/
cat /home/vagrant/.ssh/my_key_name.pub >> /home/vagrant/.ssh/authorized_keys

# copy ssh config from host to VM to prevent ssh asking to always confirm host authenticity in the script
sudo cp -a /opt/geonode-deploy/vagrant/include/config /home/vagrant/.ssh/
sudo chmod 600 /home/vagrant/.ssh/config

#  These commands run every time you ssh into the VM from your host machine. This will enable ansible to run, and activate the venv
echo 'eval `ssh-agent -s`' >> /home/vagrant/.profile
echo 'ssh-add ~/.ssh/my_key_name' >> /home/vagrant/.profile
echo 'cd /opt/my_geonode_project' >> /home/vagrant/.profile
echo 'source /opt/venv/my_geonode_project/bin/activate' >> /home/vagrant/.profile
echo 'sudo systemctl start tomcat.service' >> /home/vagrant/.profile
eval `ssh-agent -s`

echo finishing bootstrap.sh >&2
