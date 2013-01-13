
Vagrant::Config.run do |config|
  config.vm.box = "ubuntu-precise-64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.customize [
    "modifyvm", :id,
    "--memory", "1024"
  ]

  config.vm.provision :shell, :inline => "gem install chef --no-rdoc --no-ri; apt-get update"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
#    chef.data_bags_path = "data_bags"
#    chef.roles_path = "roles"
#    chef.add_role("some_role")
    chef.add_recipe("apache2")
    chef.add_recipe("mysql::server")
		chef.json = {
		  :mysql => {
		    :server_debian_password => 'debian',
		    :server_root_password => 'root',
		    :server_repl_password => 'repl'
			}
		}
    chef.add_recipe("rvm::system")
  end
end
