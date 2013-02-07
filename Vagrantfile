
Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
  config.vm.box_url = "http://files.vagrantup.com/lucid32.box"

  config.vm.customize [
    "modifyvm", :id,
    "--memory", "1024"
  ]
  config.vm.forward_port 3000, 3000

  config.vm.provision :shell, :inline => "update-locale LANG=en_US.UTF-8"
  config.vm.provision :shell, :inline => "apt-get update"
  config.vm.provision :shell, :inline => "gem install chef --no-rdoc --no-ri; apt-get update"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
#    chef.data_bags_path = "data_bags"
#    chef.roles_path = "roles"
#    chef.add_role("some_role")
    # chef.add_recipe("apache2")
    chef.add_recipe("mysql::server")
		chef.json = {
		  :mysql => {
		    :server_debian_password => 'debian',
		    :server_root_password => 'root',
		    :server_repl_password => 'repl'
			}
		}
		chef.add_recipe("mysql::ruby")
    chef.add_recipe("rvm::system") # Currently hangs when trying to get the ruby source with curl.
    chef.json[:rvm] = {
      :branch => nil
    }
    # If this happens go to the vagrant machine and run:
    # $ sudo su -
    # # cd /usr/local/rvm/archives/
    # # curl -f -L --create-dirs -C - -o bin-ruby-1.9.3-p194.tar.bz2 -# https://rvm.io/binaries/ubuntu/12.04/x86_64/ruby-1.9.3-p194.tar.bz2?rvm=1.18.3
    # # killall curl
    # Now go back to the machine running vagrant. Kill the 'vagrant up' with a double Control-C and run 'vagrant provision'.
    chef.add_recipe("build-essential")
    # chef.add_recipe("passenger_apache2")
    # subversion subversion-tools \
    
    ## libcurl4-openssl-dev (libcurl4-gnutls-dev) libopenssl-ruby \ ???
    ##  libxslt-dev (libxslt1-dev)
    ## Add gems
    ## Git checkout
    ## Compile tools
    ## Add users
    ## sshd_config
  end

  config.vm.provision :shell, :inline => "git clone https://github.com/MushroomObserver/config-script.git; config-script/run; rm -rf config-script"

end
