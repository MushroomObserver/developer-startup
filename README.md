developer-startup
=================

Welcome to the Mushroom Observer Developer Startup system!  The
purpose of this system is to help software developers setup an
environment where they can contribute to the Mushroom Observer code
base.  The basic idea is to setup a virtual machine (VM) on your
personal ("host") machine that is configured to serve a test version
of the Mushroom Observer website and to access the code. 
This system does require a reasonably powerful computer probably
purchased in the last 3 years.

>  :warning: The system has been tested with macOS, but we haven't yet
suceeded in setting it up with Windows. **Before trying a Windows
install, please get in touch with us so that we can help
work through the problems.** (The notes below about Windows relate to 
older versions of the Developer System; they may be irrelevant to the 
current version.)

If you're interested in contributing your code to MO, please also read
[DEVELOPER-WORKFLOW.md][]. Administrators/Managers should also have a
look at [ADMIN-WORKFLOW.md][].

## Creating working Mushroom Observer development environment ##

### TL;DR ###

From a clean Mac to running the tests:



Install VirtualBox: https://www.virtualbox.org/

Install Vagrant: https://www.vagrantup.com/downloads.html

Install git: http://git-scm.com/downloads

In a Terminal shell:

    git clone https://github.com/MushroomObserver/developer-startup.git
    cd developer-startup
    vagrant up
    vagrant ssh
    mo-dev /vagrant
    cd /vagrant/mushroom-observer
    rails lang:update
    rails test
    rails server -b 0.0.0.0

That should be it.  If something did not work, then see below for a
more detailed walk through which addresses the issues that have been
reported.

### Install development tools on your local machine ###

Install VirtualBox: https://www.virtualbox.org/ (Windows 10 Users:
make sure that Hyper-V is not installed as a 'Windows Feature' on your
machine as it breaks virtualbox)

Install Vagrant: https://www.vagrantup.com/downloads.html

Install git: http://git-scm.com/downloads (some Mac users have found
the GitHub GUI to be helpful, https://central.github.com/mac/latest)

If you are using Windows, it will be very helpful to select the option
in the git installer to add the Unix tools to the Windows path.  This
will make accessing the virtual box via SSH much easier.

### Clone the project ###
Get the developer-startup Git project:

    git clone https://github.com/MushroomObserver/developer-startup.git

### Run the startup script (after insuring that bundler is intalled) ###
Go into the resulting directory:

    cd developer-startup
    vagrant up

### Setup your Virtual Machine ###

Login to your new VM:

    % vagrant ssh

On Windows machines this may require installing an ssh client like
[PuTTY][].  Attempting to run `vagrant ssh` will give you the parameters
you need to give to [PuTTY][]. Note: if you have Git installed with the Unix tools
you will not need to install [PuTTY][].

You have been successful if the final output line is:

    vagrant@vagrant:~$

#### Setting up ssh access to GitHub (optional) ####

If you are using ssh to connect with github, you'll need a private key
is ~/.ssh on the VM whose public key is registered with github. You
can either generate a new key pair with:

    $ ssh-keygen -f /home/vagrant/.ssh/id_rsa -N ''

and accepting all the defaults. You then need to add ~/.ssh/id_rsa.pub
to your SSH Keys in your github settings.  You can also reuse an
existing private key by copying it to the developer-startup directory
on the host machine. Assuming the key is called id_rsa, on the VM run:

    $ mkdir ~/.ssh
    $ chmod 700 ~/.ssh
    $ mv /vagrant/id_rsa ~/.ssh
    $ chmod 600 ~/.ssh/id_rsa

#### Setup the new VM ####

    $ mo-dev /vagrant

*Gotcha for Windows users.  If you see this error:

`/bin/bash: bad interpreter: No such file or directory`

it means that the line endings of the file have been formatted for
windows when you cloned the developer-startup repository.  To fix
this, use a program like Notepad++ to convert the mo-dev file to
"Unix/Linux EOL (Line Endings)".

Note: You can give mo-dev any directory on the VM you want.  The advantage of
using /vagrant is that the MO source code will be available both on the
VM and on the host machine in the same directory as the Vagrantfile.
This is handy if you want to edit MO files on your host machine with your
normal editor. However, it usually makes the tests run more slowly on the VM.
Another common option is to just use:

    $ mo-dev .

and use Linux editors such as vi or emacs.  The rest of this document
assumes that you used /vagrant when calling mo-dev.

*Another Gotcha for Windows users:

You may need to update the the "guest additions" on the VM in order for 'folder sharing'
to work.  If you are unable to see any files in the /vagrant directory on the VM, then run
this command on your host.

    > vagrant plugins update vbguest

### Using MO on the VM ###
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
    $ rails test
    
Note if the VM has been inactive for a while or you know additional
changes have been added to the source code repository, you may want
to re-run mo-dev using the directory containing the mushroom-observer
directory.  This will run standard things like 'git pull',
'bundle install', run any pending database migrations, and make sure
your lang files are up to date.

Start web server
----------------
Go to VM (`vagrant ssh` or through [PuTTY][])

    $ cd /vagrant/mushroom-observer
    $ rails db:schema:load
    $ rails db:fixtures:load
    $ rails lang:update

Start the Rails server on the VM

    $ rails server -b 0.0.0.0

Go to http://localhost:3000 in a browser on the host machine. (Note:
one developer reports that port-forwarding required use of port 5656
instead of 3000)

Create a user in the new instance of MO
---------------------------------------
Go to http://localhost:3000/account/signup and create a new user in
your regular browser

Go to VM (`vagrant ssh` or through [PuTTY][]):

    $ grep verify /vagrant/mushroom-observer/log/development.log

Note: this information can also be found on the host machine by
looking in develop-startup/mushroom-observer/log/development.log

Go to verification URL in your browser

Have fun!  (Note the initial database, developer-startup/init.sql,
just has the admin user and the language stuff.  It probably makes
sense to add some observations, names and images for testing, but we
haven't gotten to it yet.)

# Next: Contribute to MO code development

To contribute to MO code development, please follow the suggestions in
[DEVELOPER-WORKFLOW.md][].
-----------------------------------

Resetting your VM
-----------------
If something goes wrong or you simply want to start over from scratch,
on the host machine run:

    % vagrant destroy
    % rm -rf mushroom-observer
    % vagrant up

and continue as above after the original vagrant up.

Rebuilding the Vagrant box from scratch
---------------------------------------
If for some reason the VM created using the ./startup does not work or
it gets outdated and you wish to refresh it, you can build a new VM
from scratch.  First, you may want to update the base box in the
Vagrantfile.  Once you have the base box you want, run:

    % vagrant up clean

Once the VM is setup, you should create a new version of the box with:

    % vagrant package clean

This will create a package.box file in the developer-startup
directory.  To allow others to use it, this should get uploaded to
http://images.mushroomobserver.org and placed in the web root
directory under a distinct name.  Finally, the Vagrantfile should be
updated to reference the new box and checked in.

Other developers should now be able to get the upgraded box by simply
updating their local developer-startup repo and running:

    % vagrant destroy
    % vagrant up

They may also want to get rid of any old boxes by running:

    % vagrant box list
    % vagrant box remove [boxname] 

- - -
[comment]: # (The following are link reference definitions)
[ADMIN-WORKFLOW.md]: /ADMIN-WORKFLOW.md
[Bundler]: http://bundler.io/
[DEVELOPER-WORKFLOW.md]: /DEVELOPER-WORKFLOW.md/
[PuTTY]: http://www.putty.org/
[RVM]: https://rvm.io/
