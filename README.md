developer-startup
=================

Information and script for creating a full Mushroom Observer development environment using VirtualBox and Vagrant/Chef


Create working environment
=================
On MacOS 10.8.2:
1) Install VirtualBox
2) Install git (on Mac use the GitHub GUI)
3) Install gcc 4.2 compiler for rvm/ruby (on Mac that currently involves installing Xcode from the App Store including the Command Line Tools (Preferences => Downloads and install 'Command Line Tools'))
4) Install rvm (on Mac first install just rvm (\curl -L https://get.rvm.io | bash -s stable), then run 'rvm requirements'.  Then install Homebrew (ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)") and resolve all the requirements.  Currently that means 'brew update; brew tap homebrew/dupes; brew install autoconf automake apple-gcc42 libtool pkg-config openssl readline libyaml sqlite libxml2 libxslt libksba'.  Now install ruby using RVM: \curl -L https://get.rvm.io | bash -s stable --ruby [Perhaps 'rvm install 1.9.3' would work just as well].  Finally, open a new shell and check the version of ruby with 'ruby --version')
5) % git clone https://github.com/MushroomObserver/developer-startup.git
6) % cd developer-startup
7) % ./startup
8) Wait for a while... (5m3.661s on my Mac)

Assuming that was successful, you now have a running virtual machine with the MO source code installed, an instance of MySQL and all the goodies to successfully run all the tests and startup a local server (see below).  MySQL can be accessed with usernames/passwords mo/mo or root/root.

Note ./startup requires bash.  If you don't have bash, you can just run the 4 listed shell commands by hand.
They make sure vagrant and the Chef librarian are installed.  Runs the librarian to get the needed cookbooks described in the Cheffile in developer-startup.  Then runs 'vagrant up' which using the Vagrantfile to do the actual build.  An important part of the build is controlled by the 'run' script in another GitHub project, https://github.com/MushroomObserver/config-script.git, which vagrant automatically downloads to the new machine and runs.

To run the tests in the new environment
=================
1) Go to vagrant machine (% vagrant ssh)
2) $ cd /vagrant/mushroom-observer
3) $ script/run_tests

Start web server
=================
1) Go to vagrant machine (% vagrant ssh)
2) $ cd /vagrant/mushroom-observer
3) $ script/server
4) Go to http://localhost:3000 in a browser

Create a user in the new instance of MO
=================
1) Go to http://localhost:3000/account/signup and create a new user in your regular browser
2) Go to vagrant machine (% vagrant ssh)
3) $ grep verify /vagrant/mushroom-observer/log/developer.log
4) Go to verification URL in your browser
5) Have fun!  (Note the initial database, developer-startup/init.sql, just has the admin user and the language stuff.  It probably makes sense to add some observations, names and images for testing, but I haven't gotten to it yet.)

Edit code
=================
In your developer-startup directory there will be a 'mushroom-observer' directory.  This is a 'shared folder' which is the same as /vagrant/mushroom-observer on the VM.  You can change code here on either machine and it will be picked up by the server on the VM.
