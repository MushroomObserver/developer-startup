developer-startup
=================

Information and script for creating a full Mushroom Observer development environment using VirtualBox and Vagrant/Chef


Create working environment
=================
1) Install VirtualBox
2) Install ruby
3) Install git
4) % git clone https://github.com/MushroomObserver/developer-startup.git
5) % cd developer-startup
6) % ./startup
7) Wait for a while... (5m3.661s on my Mac)

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
