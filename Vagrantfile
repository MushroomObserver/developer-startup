# -*- mode: ruby -*-
# vi: set ft=ruby :

RUBY_V = if File.exist?("./mushroom-observer/.ruby-version")
           File.read("./mushroom-observer/.ruby-version").chomp
         else
           "3.1.4"
         end

# from the example at https://gist.github.com/creisor/e20f254a89070f46b91cc3e0c5cd18db
mo_apt_script = <<~SCRIPT
  update-locale LANG=en_US.UTF-8
  apt-get update --fix-missing
  DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
  debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
  debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
  apt-get -y install mysql-server
  apt-get -y install libmysqlclient-dev
  sed "s/\\[mysqld\\]/[mysqld]\\nsql-mode = ''/" -i'' /etc/mysql/mysql.conf.d/mysqld.cnf
  ln -fs /vagrant/mo-dev /usr/local/bin/mo-dev
  apt-get -y install git build-essential wget curl vim ruby imagemagick \
    libmagickcore-dev libmagickwand-dev libjpeg-dev libgmp3-dev gnupg2 \
    chromium-browser
SCRIPT

# their rbenv example, unaltered except the line cd /vagrant/mushroom-observer
# uses our .ruby-version, found above
# makes a `cdable_vars` alias `mo` for /vagrant/mushroom-observer
mo_rbenv_script = <<~SCRIPT
  if [ ! -d ~/.rbenv ]; then
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv --verbose
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  fi
  if [ ! -d ~/.rbenv/plugins/ruby-build ]; then
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build --verbose
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
  fi
  export PATH="$HOME/.rbenv/bin:$PATH"
  export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
  eval "$(rbenv init -)"
  if [ ! -e .rbenv/versions/#{RUBY_V} ]; then
    rbenv install #{RUBY_V}
  fi
  rbenv global #{RUBY_V}
  cd /vagrant/mushroom-observer
  if [ ! -e /home/vagrant/.rbenv/shims/bundle ]; then
    gem install bundler
    rbenv rehash
  fi
  if [ -f "./Gemfile" ]; then
    bundle install
  fi
  shopt -s cdable_vars
  mo=/vagrant/mushroom-observer
SCRIPT

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  if ARGV[1] == "clean-jammy"
    config.vm.define("clean-jammy") do |clean|
      # The most common configuration options documented and commented below.
      # For a complete reference, please see the online documentation at
      # https://docs.vagrantup.com.

      # Every Vagrant development environment requires a box.
      # You can search for boxes at https://vagrantcloud.com/search.
      config.vm.box = "ubuntu/jammy64"

      clean.vm.provider("virtualbox") do |vb|
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize(["modifyvm", :id, "--memory", "2048"])
      end

      clean.vm.network("forwarded_port", guest: 3000, host: 3000)

      clean.vm.provision(:shell, inline: mo_apt_script)

      clean.vm.provision(:shell, privileged: false, inline: mo_rbenv_script)

      clean.trigger.after([:provision]) do |t|
        t.name = "Reboot after provisioning"
        t.run = { inline: "vagrant box update" }
        t.run = { inline: "vagrant reload clean" }
      end
    end
  else
    version_date = "2023-10-21"
    config.vm.define("mo-jammy-#{version_date}", primary: true) do |mo|
      mo.vm.box = "mo-jammy-#{version_date}"
      mo.vm.box_url = "https://images.mushroomobserver.org/mo-jammy-#{version_date}.box"
      # mo.vm.box_url = "/Users/nimmo/Documents/GitHub/developer-startup/mo-jammy-2023-09-01.box"
      mo.vm.network("forwarded_port", guest: 3000, host: 3000)
      mo.vm.provider("virtualbox") do |vb|
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize(["modifyvm", :id, "--memory", "2048"])
      end
    end
  end
end
