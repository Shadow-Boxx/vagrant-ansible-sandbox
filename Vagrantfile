# Defines our Vagrant environment
#
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # create mgmt/on-ramp node
  config.vm.define :mgmt do |mgmt_config|
      mgmt_config.vm.box = "centos-7.2-x64"
      mgmt_config.vm.hostname = "mgmt"
      mgmt_config.vm.network :public_network, ip: "192.168.1.120", bridge: "Intel Ethernet"
      mgmt_config.vm.provider "virtualbox" do |vb|
        vb.memory = "256"
      end
      mgmt_config.vm.provision :shell, path: "bootstrap-mgmt.sh"
  end

  # create an HAProxy load balancer
#  config.vm.define :lb do |lb_config|
#      lb_config.vm.box = "centos-7.2-x64"
#      lb_config.vm.hostname = "lb"
#      lb_config.vm.network :private_network, ip: "192.168.56.121"
#      lb_config.vm.network "forwarded_port", guest: 80, host: 8080
#      lb_config.vm.provider "virtualbox" do |vb|
#        vb.memory = "256"
#      end
#  end

  # create some web servers
  (1..2).each do |i|
    config.vm.define "node#{i}" do |node|
        node.vm.box = "centos-7.2-x64"
        node.vm.hostname = "node#{i}"
        node.vm.network :public_network, ip: "192.168.1.13#{i}", bridge: "Intel Ethernet"
        node.vm.network "forwarded_port", guest: 80, host: "808#{i}"
        node.vm.provider "virtualbox" do |vb|
          vb.memory = "256"
        end
    end
  end

end
