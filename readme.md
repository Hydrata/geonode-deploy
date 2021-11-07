# geonode-deploy

### Overview
There are two related projects here.

Firstly, a vagrant script is used to build and maintain a standardised virtual machine 
on the developer's laptop (the "vagrant VM"). 

Secondly, ansible is used to deploy and manage geonode and supporting packages to the 
vagrant VM and any staging/test/production servers.

We use the vagrant VM as the ansible host machine. Yes, this means that the vagrant VM
uses ansible to deploy geonode onto itself, via the `localhost` inventory. 

### Vagrant
#### Dependencies
On your laptop:  
Install vagrant from https://vagrantup.com  
Install Oracle VirtualBox from https://www.virtualbox.org/

#### Setup Directories and Other Repositories
On the host machine (your laptop):
```
git clone https://github.com/Hydrata/geonode-deploy.git
```
Vagrant assumes that you have cloned this repo under the same parent directory as `geonode`, `geonode-mapstore-client` and `my_geonode_project`. 
If this is the case, these directories will be synced between the host laptop and the vagrant VM, according to the `synced_folder` configurations
in the `Vagrantfile`. You may want to customise these, depending on your configurations.

The folder structure should look like this:

```
--some_other_directory_out_of_scope
--parent_directory_any_name
----geonode
----geonode-mapstore-client
----my_geonode_project
----geonode-deploy
--another_directory_out_of_scope
```

#### Setup ssh keys
The `../geonode-deploy/vagrant/include/` directory allows us to conventiently pass files from the 
host machine (your laptop) to the vagrant VM. Any files in this directory will be available to both 
machines. 

Now, recall that we ultimately want to deploy code from the vagrant VM, to our
prod/staging/dev servers using Ansible. One of the key benefits of Ansible is that it can 
build a server purely via ssh access. In order to do this, we need to give the vagrant VM the 
ability to ssh into the target servers.

A script, `bootstrap.sh`, will copy the private/public keypairs to the right locations on 
the vagrant VM, in order for them to be available to ansible. You will need to customise the 
filenames in this script to match your keypairs. The steps are as follows:
1. Replace  
```../geonode-deploy/vagrant/include/my_key_name``` and</br>
```../geonode-deploy/vagrant/include/my_key_name.pub``` </br>
with your own private/public keypair
2. Modify `bootstrap.sh` to replace `my_key_name` with your actual key name

#### Using "geonode-project"
Replace `my_geonode_project` with your `<actual>` geonode project name in both 
`./geonode-deploy/vagrant/bootstrap.sh` and `./geonode-deploy/vagrant/Vagrantfile`

#### Launch the Vagrant VM on your laptop
Now simply:
```
cd ../geonode-deploy/vagrant
vagrant up
```


### A note on use-cases
Deploying and maintaining geonode can be complex. The simplest method is NOT
to use this repository. The simplest method is to use docker via the dockerfile in the
main geonode repository. If you are new to web development and learning geonode, that 
is the path we recommend you.

However, if you
* require more granular control over your geonode machines and operating systems,
* want to customise the front-end code, environment or add additional projects,
* are maintaining other ansible projects on your geonode machines,
* don't want to/can't use docker for a specific reason,
* have experience using ansible and/or managing applications running within linux/debian/ubuntu,

then this repo is worth a look.