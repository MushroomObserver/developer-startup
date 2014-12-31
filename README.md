developer-startup
=================

Welcome to the Mushroom Observer Developer Startup system!  The
purpose of this system is to help software developers setup an
environment where they can contribute to the Mushroom Observer code
base.  The basic idea is to setup a virtual machine (VM) on your
personal machine that is configured to serve a test version of the
Mushroom Observer website and to access the code.  It has been tested
on Macintoshes as well as PCs running either Windows or Ubuntu.  This
system does require a reasonably powerful computer probably purchased
in the last 3 years.

If you're interested in contributing your code to MO, please also read
/developer-workflow.md

[![CodePolice][5]][6]

Creating working Mushroom Observer development environment
--------------------------
Install VirtualBox: https://www.virtualbox.org/

Install Vagrant: https://www.vagrantup.com/downloads.html

Install git: http://git-scm.com/downloads (on my Mac I've found the
GitHub GUI can be helpful, https://central.github.com/mac/latest)

Get the developer-startup Git project:

    % git clone https://github.com/MushroomObserver/developer-startup.git

Go into the resulting directory:

    % cd developer-startup

If you have bash installed (true by default on Linux and MacOSX),
run the startup script.  It is also important to make sure that you have the bundler package installed.
On Ubuntu linux, this can be done by typing ```sudo apt-get bundler``` in the terminal:

    % ./startup

Otherwise, just run the commands in ./startup from any command-line tool.

Wait for a while...

Login to your new VM:

    % vagrant ssh

On Windows machines this may require installing an ssh client like
Putty.  Attempting to run 'vagrant ssh' will give you the parameters
you need to give to Putty.

You have been successful if the final output line is:

    vagrant@vagrant-ubuntu-trusty-64:~$

(If you are using ssh to connect with github, you'll need to copy your
private key into /home/vagrant/.ssh/id_rsa before proceeding.)

Setup the new VM by running:

    vagrant@vagrant-ubuntu-trusty-64:~$ `mo-dev /vagrant`

You can actually use any directory on the VM you want.  The advantage of
using /vagrant is that the MO source code will be available both on the
VM and on the host machine in the same directory as the Vagrantfile.
This can be handy if you are use to an editor on the host machine.
However, it usually makes the tests run more slowly on the VM.  The rest
of this document assumes that you used /vagrant when calling mo-dev.

Assuming all of that was successful, you now have a running virtual
machine with the MO source code installed, an instance of MySQL and
all the goodies to successfully run all the tests and startup a local
server (see below).  You access the new machine by being in the
developer-startup directory and running 'vagrant ssh' or through
Putty.  The new instance of MySQL can be accessed with
usernames/passwords mo/mo or root/root.

To run the tests in the new environment
---------------------------------------
Go to the VM ('vagrant ssh' or through Putty)

    $ cd /vagrant/mushroom-observer
    $ rake

Note if the VM has been inactive for a while or you know additional
changes have been added to the source code repository, you may want
to re-run mo-dev using the directory containing the mushroom-observer
directory.  This will run standard things like 'git pull',
'bundle install', run any pending database migrations, and make sure
your lang files are up to date.

Start web server
----------------
Go to VM ('vagrant ssh' or through Putty)

    $ cd /vagrant/mushroom-observer
    $ rails server

Go to http://localhost:3000 in a browser on the host machine (note:
one developer reports that port-forwarding required use of port 5656
instead of 3000)

Create a user in the new instance of MO
---------------------------------------
Go to http://localhost:3000/account/signup and create a new user in
your regular browser

Go to VM ('vagrant ssh' or through Putty):

    $ grep verify /vagrant/mushroom-observer/log/development.log

Note: this information can also be found on the host machine by
looking in develop-startup/mushroom-observer/log/development.log

Go to verification URL in your browser

Have fun!  (Note the initial database, developer-startup/init.sql,
just has the admin user and the language stuff.  It probably makes
sense to add some observations, names and images for testing, but I
haven't gotten to it yet.)

Contributing to MO code development
-----------------------------------
To contribute to MO code development, please follow the suggestions in
/developer-workflow.md

Resetting your VM
-----------------
If something goes wrong or you simply want to start over from scratch,
on the host machine run:

    % vagrant destroy
    % rm -rf mushroom-observer
    % ./startup

and continue as above after the original ./startup.

Rebuilding the Vagrant box from scratch
---------------------------------------
If for some reason the VM created using the ./startup does not work or
it gets outdated for some reason.  You can build a new VM from scratch
using the ./build script.  Most of the files in developer-startup are
there solely to support this rebuild process.

Once the ./build script completes you should have a fresh clean VM
that is equivalent to what you get after you run ./startup.

For those maintaining the Mushroom Observer VM, once you finish the
./build script, you can create a new version of the box with:

    % vagrant package

This will create a package.box file in the developer-startup
directory.  To allow others to use it, this should get uploaded
to http://images.digitalmycology.com and the Vagrantfile should
be updated to reference the new box and checked in.
