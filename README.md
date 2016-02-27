# Vagrant-Ansible Sandbox
VA Sandbox (VAS) is an environment for development experimentation. It automates the creation of disposable VM environments that can be used to test ideas, configurations and settings, that otherwise would be painful to create and maintain manually.

Table of Contents
=================

  * [Vagrant\-Ansible Sandbox](#vagrant-ansible-sandbox)
    * [How is this Sandbox organized](#how-is-this-sandbox-organized)
    * [How to use it](#how-to-use-it)
        * [This is it\! Happy experimentation\!](#this-is-it-happy-experimentation)

## Prerequisites
This sandbox assumes the following software is already setup on your local laptop / workstation:

  + Virtualbox for creating and running VMs locally. Though one can use VMWare or KVM.
  + Vagrant
  + Access to Virtualbox images. We provide a URL to


## How is this Sandbox organized
The sandbox provides a management node 'mgmt' VM and bunch of other VMs that can be wired together in flexible configurations. The management node is a ramp node and should be used to initiate all types of experimentation and is the only node that needs Ansible to be installed on it. This way, there is no need to install anything additional on the local laptop, and it makes a clean way to setup and tear down the sandboxes. Once the experimentations are done, all the VMs can be safely destroyed.

The sample Vagrantfile included here lists the management node:

```text
# create mgmt/on-ramp node
config.vm.define :mgmt do |mgmt_config|
    mgmt_config.vm.box = "centos-7.1-x64"
    mgmt_config.vm.hostname = "mgmt"
    mgmt_config.vm.network :private_network, ip: "192.168.56.120"
    mgmt_config.vm.provider "virtualbox" do |vb|
      vb.memory = "256"
    end
    mgmt_config.vm.provision :shell, path: "bootstrap-mgmt.sh"
end
```
Management node is provisioned via `bootstrap-mgmt.sh` shell script, after it is properly initialized by the underlying hypervisor. It:

  + Installs Ansible and some other useful tools on the management node,
  + Copies all the ansible playbooks in the `/home/vagrant/setup` directory.
  + Installs a kick-ass prompt. Frankly I got bored with the plain prompt which is not very useful, and
  + Updates the `/etc/hosts` file to list all the other nodes that the management node can reach.

There is a load-balancer VM configuration also provided as an example. If there is no need to a load balancer, then comment out the section from the Vagrantfile.

The Vagrantfile also lists the VM configurations of worker nodes as follows:

```text
# create some web servers
(1..2).each do |i|
  config.vm.define "node#{i}" do |node|
      node.vm.box = "centos-7.1-x64"
      node.vm.hostname = "node#{i}"
      node.vm.network :private_network, ip: "192.168.56.13#{i}"
      node.vm.network "forwarded_port", guest: 80, host: "808#{i}"
      node.vm.provider "virtualbox" do |vb|
        vb.memory = "256"
      end
  end
end
```
One can create as many VMs as needed by using the above construct.

## How to use it
Most common use case for VAS is to be able to create local VMs using Vagrant. You can also technically use it with various cloud providers, like Amazon AWS, Digital Ocean etc.

1. Edit Vagrantfile to suit your needs for the number of VMs you need.
    1. Make sure to edit the static network interfaces to match your own network subnets, if different.
    2. Keep or remove the load-balancer VM.
    3. Update the number of worker nodes needed for the setup. Make sure to update or remove the port forwarding of the worker nodes.
    4. All the VMs are configured with 256MB RAM, which is enough for small scale experimentation. You can adjust the memory size if necessary.

2. Do `vagrant up` to bring up all nodes. Give it a few mins.
3. Do `vagrant ssh mgmt` to log into the management node and perform the desired experimentation.
4. In the mgmt node, check ansible version: `ansible --version` to make sure that the latest version is properly installed.
5. Go to the "setup" directory by doing `cd setup`. The ansible playbooks are structured with a number of roles.
6. Edit the **inventory.txt** file to reflect the proper number of nodes ansible has to provision. Comment the extra ones.
7. Run the ansible playbooks using the syntax `ansible-playbook site.yml`.

> NOTE that **ansible.cfg** file has a special flag called `ask_pass=True`. This is only needed for the first run. It asks for **vagrant** username (password vagrant). It makes sense to comment out this line after the successful first run. 

####This is it! Happy experimentation!
