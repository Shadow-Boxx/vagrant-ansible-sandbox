ß#!/usr/bin/env bash

###############################################################
# This script will setup the management node with all the
# necessary bits to run Ansible and other useful utilities.
###############################################################

# Install Ansible from EPEL
yum install -y epel-release
yum install -y ansible

# Install useful utilities
yum install -y net-tools the_silver_searcher ack vim

# Copy ansible playbooks into /home/vagrant/setup directory of the mgmt node.
# This way they are cleanly separated from everything else.
mkdir -p /home/vagrant/setup
cp -a /vagrant/mgmt/* /home/vagrant/setup
chown -R vagrant:vagrant /home/vagrant/setup

# Create an awesome bash prompt
cat >> /home/vagrant/.bash_profile <<EOP

# Set proper shell prompt
export PS1="\n\[\033[1;37m\](\[\033[0;31m\]\u\[\033[0;37m\]@\[\033[0;33m\]\H\[\033[1;37m\])\342\224\200(\[\033[1;34m\]\@ \d\[\033[1;37m\])\[\033[1;37m\]\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\]) \[\033[0m\]\n\[\033[1;37m\]\$ \[\033[0m\]"

# Custom bash prompt via kirsle.net/wizards/ps1.html
# export PS1="\[$(tput bold)\]\[$(tput setaf 7)\](\[$(tput setaf 6)\]\u\[$(tput setaf 4)\]@\[$(tput setaf 1)\]\H\[$(tput setaf 7)\])-(\[$(tput setaf 2)\]\W\[$(tput setaf 7)\])\n\\$ \[$(tput sgr0)\]"
EOP


# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL

# vagrant environment nodes
192.168.56.120  mgmt
192.168.56.121  lb
192.168.56.131  node1
192.168.56.132  node2
192.168.56.133  node3
192.168.56.134  node4
192.168.56.135  node5
192.168.56.136  node6
192.168.56.137  node7
192.168.56.138  node8
192.168.56.139  node9
EOL
