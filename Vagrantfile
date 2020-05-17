# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  if ARGV[1] == "clean"
    config.vm.define "clean" do |clean|
      # The most common configuration options are documented and commented below.
      # For a complete reference, please see the online documentation at
      # https://docs.vagrantup.com.

      # Every Vagrant development environment requires a box. You can search for
      # boxes at https://vagrantcloud.com/search.
      config.vm.box = "hashicorp/bionic64"

      clean.vm.provider "virtualbox" do |vb|
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--memory", "2048"]
      end

      clean.vm.network "forwarded_port", guest: 3000, host: 3000

      clean.vm.provision :shell, inline: <<-SHELL
        update-locale LANG=en_US.UTF-8
        apt-get -y update
        debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
        debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
        apt-get -y install mysql-server
        apt-get -y install libmysqlclient-dev
        ln -fs /vagrant/mo-dev /usr/local/bin/mo-dev
        apt-get -y install git build-essential wget curl vim emacs \
          imagemagick libmagickcore-dev libmagickwand-dev libjpeg-dev
      SHELL
    end
  else
    config.vm.define "mo", primary: true do |mo|
      mo.vm.box = "mo-bionic-beaver"
      mo.vm.box_url = "http://images.mushroomobserver.org/mo-bionic-beaver.box"
      mo.vm.network "forwarded_port", guest: 3000, host: 3000
      mo.vm.provider "virtualbox" do |vb|
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--memory", "2048"]
      end
    end
  end
end
