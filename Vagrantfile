# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  if ARGV[1] == "clean-focal"
    config.vm.define "clean-focal" do |clean|
      # The most common configuration options are documented and commented below.
      # For a complete reference, please see the online documentation at
      # https://docs.vagrantup.com.

      # Every Vagrant development environment requires a box. You can search for
      # boxes at https://vagrantcloud.com/search.
      config.vm.box = "ubuntu/focal64"

      clean.vm.provider "virtualbox" do |vb|
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--memory", "2048"]
      end

      clean.vm.network "forwarded_port", guest: 3000, host: 3000

      clean.vm.provision :shell, inline: <<-SHELL
        update-locale LANG=en_US.UTF-8
        apt-get -y update
        DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
        debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
        debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
        apt-get -y install mysql-server
        apt-get -y install libmysqlclient-dev
        sed "s/\\[mysqld\\]/[mysqld]\\nsql-mode = ''/" -i'' /etc/mysql/mysql.conf.d/mysqld.cnf
        ln -fs /vagrant/mo-dev /usr/local/bin/mo-dev
        apt-get -y install git build-essential wget curl vim ruby \
          imagemagick libmagickcore-dev libmagickwand-dev libjpeg-dev \
          libgmp3-dev gnupg2
      SHELL

      clean.vm.provision :shell, privileged: false, inline: <<-SHELL
        gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
        curl -L https://get.rvm.io | bash -s stable
        source ~/.rvm/scripts/rvm
        rvm install 2.7.6
      SHELL

      clean.trigger.after [:provision] do |t|
        t.name = "Reboot after provisioning"
        t.run = { :inline => "vagrant reload clean" }
      end
    end
  else
    version_date = "2022-06-04"
    config.vm.define "mo-focal-#{version_date}", primary: true do |mo|
      mo.vm.box = "mo-focal-#{version_date}"
      mo.vm.box_url = "http://images.mushroomobserver.org/mo-focal-#{version_date}.box"
      mo.vm.network "forwarded_port", guest: 3000, host: 3000
      mo.vm.provider "virtualbox" do |vb|
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--memory", "2048"]
      end
    end
  end
end
