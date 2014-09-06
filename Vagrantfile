# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if ARGV[1] == 'clean'
    # All Vagrant configuration is done here. The most common configuration
    # options are documented and commented below. For a complete reference,
    # please see the online documentation at vagrantup.com.
    
    # Every Vagrant virtual environment requires a box to build off of.
    config.vm.box = "ubuntu/trusty64"
    
    config.vm.provider "virtualbox" do |vb|
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    
    config.vm.network "forwarded_port", guest: 3000, host: 3000
    
    config.vm.provision :shell, :inline => "update-locale LANG=en_US.UTF-8"
    config.vm.provision :shell, :inline => "apt-get update; apt-get install ruby1.9.1-dev"
    config.vm.provision :shell, :inline => "gem install chef --no-rdoc --no-ri; apt-get update"
    config.vm.provision :shell, :inline => "ln -fs /vagrant/mo-dev /usr/local/bin/mo-dev"
    
    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "apt"
      chef.add_recipe "build-essential"
      chef.add_recipe "git"
    
      chef.add_recipe("imagemagick::rmagick")
      chef.add_recipe("mysql::server")
    		chef.json = {
    		  :mysql => {
    		    :server_debian_password => 'debian',
    		    :server_root_password => 'root',
    		    :server_repl_password => 'repl'
    			}
    		}
      chef.add_recipe "mysql::client"
    end
  else
    config.vm.box = "mo-31"
    config.vm.box_url = "http://images.digitalmycology.com/mo-31.box"
    config.vm.network "forwarded_port", guest: 3000, host: 3000
  end
end
