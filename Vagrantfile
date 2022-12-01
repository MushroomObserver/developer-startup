# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
#
# Use `apt-get`, not `apt`, in these commands to avoid warnings.
#
Vagrant.configure("2") do |config|
  if ARGV[1] == "clean-jammy"
    config.vm.define "clean-jammy" do |clean|
      # The most common configuration options are documented and commented below.
      # For a complete reference, please see the online documentation at
      # https://docs.vagrantup.com.

      # Every Vagrant development environment requires a box. You can search for
      # boxes at https://vagrantcloud.com/search.
      config.vm.box = "ubuntu/jammy64"

      clean.vm.provider "virtualbox" do |vb|
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        # Open the gui for debugging, while updating this Vagrantfile
        # vb.gui="true"
      end

      clean.vm.network "forwarded_port", guest: 3000, host: 3000

      # Silence warnings "dpkg-preconfigure: unable to re-open stdin"
      # Must come before any `apt-get` calls
      config.vm.provision :shell, inline: <<-SHELL
        update-locale LANG=en_US.UTF-8
        export DEBIAN_FRONTEND=noninteractive
      SHELL

      # Update repositories
      config.vm.provision :shell, inline: "apt-get -y update"

      # Upgrade installed packages
      config.vm.provision :shell, inline: "apt-get upgrade -y"

      # Add Debian and MySQL server
      clean.vm.provision :shell, inline: <<-SHELL
        apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
        debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
        debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
        apt-get -y install mysql-server
        apt-get -y install libmysqlclient-dev
        sed "s/\\[mysqld\\]/[mysqld]\\nsql-mode = ''/" -i'' /etc/mysql/mysql.conf.d/mysqld.cnf
        ln -fs /vagrant/mo-dev /usr/local/bin/mo-dev
        apt-get -y install git build-essential wget curl vim ruby \
          imagemagick libmagickcore-dev libmagickwand-dev libjpeg-dev \
          libgmp3-dev
      SHELL

      # Add public key for rvm and install rvm.
      clean.vm.provision :shell, privileged: false, inline: <<-SHELL
        # Note: rvm's listed keyservers (incl. MIT.edu) are extremely
        # unreliable. Hours of inexplicable failure to find the public keys.
        # Pro tip - do not use keyservers at all! Grrrrrrrrrr. - AN 11/2022
        # These may be less secure than keyservers, but at least they load.
        curl -sSL https://rvm.io/mpapis.asc | gpg --import -
        curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
        # Trust them keys
        echo 409B6B1796C275462A1703113804BB82D39DC0E3:6: | gpg --import-ownertrust # mpapis@gmail.com
        echo 7D2BAF1CF37B13E2069D6956105BD0E739499BDB:6: | gpg --import-ownertrust # piotr.kuczynski@gmail.com

        curl -sSL https://get.rvm.io | bash -s stable
        source ~/.rvm/scripts/rvm

        rvm use --default --install 3.1.2
        # gem install bundler
        # gem install railties
        rvm cleanup all
      SHELL

      # # Add Google Chrome repository and install
      # config.vm.provision :shell, inline: <<-SHELL
      #   wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub|sudo apt-key add -
      #   sudo sh -c 'echo \"deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main\" > /etc/apt/sources.list.d/google.list'
      #   # Add Google Chrome for selenium tests
      #   sudo apt install -y google-chrome-stable

      #   # This simpler way didn't work:
      #   # wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/
      #   # dpkg -i ~/google-chrome*.deb"
      #   # apt-get install -f -y"
      # SHELL

      # Add Firefox for selenium. Slow: Do this last in case troubleshooting.
      config.vm.provision :shell, inline: "apt-get install -y firefox"

      clean.trigger.after [:provision] do |t|
        t.name = "Reboot after provisioning"
        t.run = { :inline => "vagrant reload clean" }
      end
    end
  else
    version_date = "2022-11-30"
    config.vm.define "mo-jammy-#{version_date}", primary: true do |mo|
      mo.vm.box = "mo-jammy-#{version_date}"
      mo.vm.box_url = "https://images.mushroomobserver.org/mo-jammy-#{version_date}.box"
      mo.vm.network "forwarded_port", guest: 3000, host: 3000
      mo.vm.provider "virtualbox" do |vb|
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--memory", "2048"]
      end
    end
  end
end
