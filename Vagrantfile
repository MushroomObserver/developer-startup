# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version.
# Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if ARGV[1] == "clean"
    config.vm.define "clean" do |clean|
      # All Vagrant configuration is done here. The most common configuration
      # options are documented and commented below. For a complete reference,
      # please see the online documentation at vagrantup.com.
      
      # Every Vagrant virtual environment requires a box to build off of.
      clean.vm.box = "ubuntu/trusty64"
      
      clean.vm.provider "virtualbox" do |vb|
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--memory", "2048"]
      end
      
      clean.vm.network "forwarded_port", guest: 3000, host: 3000
      
      clean.vm.provision :shell, :inline => "update-locale LANG=en_US.UTF-8"
      clean.vm.provision :shell, :inline => "apt-get -y update; apt-get -y install ruby1.9.1-dev"
      clean.vm.provision :shell, path: "mysql-init.sh", privileged: true
      clean.vm.provision :shell, :inline => "gem install chef --no-rdoc --no-ri; apt-get update"
      clean.vm.provision :shell, :inline => "ln -fs /vagrant/mo-dev /usr/local/bin/mo-dev"
      
      clean.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = "cookbooks"
        chef.add_recipe "apt"
        chef.add_recipe "build-essential"
        chef.add_recipe "git"
        chef.add_recipe("imagemagick::rmagick")
      end
    end
  else
    config.vm.define "mo", primary: true do |mo|
      mo.vm.box = "mo-40-1"
      mo.vm.box_url = "http://images.mushroomobserver.org/mo-40-1.box"
      mo.vm.network "forwarded_port", guest: 3000, host: 3000
      mo.vm.provider "virtualbox" do |vb|
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--memory", "2048"]
      end
    end
  end
end
