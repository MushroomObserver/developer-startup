developer-startup
=================

Welcome to the Mushroom Observer Developer Startup system!  The
purpose of this system is to help software developers setup an
environment where they can contribute to the Mushroom Observer code
base.  The basic idea is to setup a virtual machine (VM) on your
personal ("host) machine that is configured to serve a test version of the
Mushroom Observer website and to access the code.  It has been tested
on Macintoshes as well as PCs running either Windows or Ubuntu.  This
system does require a reasonably powerful computer probably purchased
in the last 3 years.

If you're interested in contributing your code to MO, please also read
[developer-workflow.md][]. Administrators/Managers should also have a look at
[admin-workflow.md][].

## Creating working Mushroom Observer development environment ##

### TL;DR ###

From a clean Mac to running the tests:

Install VirtualBox: https://www.virtualbox.org/

Install Vagrant: https://www.vagrantup.com/downloads.html

Install git: http://git-scm.com/downloads

In a Terminal shell:

    git clone https://github.com/MushroomObserver/developer-startup.git
    cd developer-startup
    ./startup
    vagrant ssh
    mo-dev /vagrant
    source /home/vagrant/.rvm/scripts/rvm
    cd /vagrant/mushroom-observer
    rake

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

### Clone the project ###
Get the developer-startup Git project:

    git clone https://github.com/MushroomObserver/developer-startup.git

### Run the startup script (after insuring that bundler is intalled) ###
Go into the resulting directory:

    cd developer-startup

What you do next depends on your local machine's operating system:

#### Linux and MacOSXL ####
>If you have bash installed (true by default), run the
startup script.  Please note: It is also important to make sure that you have
the bundler package installed.  On some Linux distributions including Ubuntu
you may have to type```sudo apt-get install bundler``` in the terminal before
running the script below.

    `% ./startup`
> Wait for a while...

#### Windows ####
> Download Ruby for Windows at http://rubyinstaller.org/.  When
>installing make sure that you check "Add Ruby executables to your
>PATH", it is not checked by default.  You must also install the
>DevKit for windows which can also be downloaded from the same
>page. At this point you should have installed Ruby and
>Devkit. Helpful instructions for install DevKit can be found here:
>http://stackoverflow.com/a/8463500/1424115

> Install Bundler in the /developer-startup directory.

`C:/developer-startup> gem install bundler`

>Note: if you receive the following error

`SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed`

>please visit
>https://gist.github.com/luislavena/f064211759ee0f806c88 and follow
>the instructions to resolve the issue, it is an easy fix.

> At this point you should have bundler installed.

> Run the following command:

`C:\developer-startup>bundle install`

`C:\developer-startup>vagrant up`

> Wait for a while...

### Setup your Virtual Machine ###

Login to your new VM:

    % vagrant ssh

On Windows machines this may require installing an ssh client like
[PuTTY][].  Attempting to run `vagrant ssh` will give you the parameters
you need to give to [PuTTY][].

You have been successful if the final output line is:

    vagrant@vagrant-ubuntu-trusty-64:~$

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
    $ cp /vagrant/id_rsa ~/.ssh
    $ chmod 600 ~/.ssh/id_rsa

#### Setup the new VM ####

    $ mo-dev /vagrant

*Gotcha for Windows users.  If you see this error

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

#### Fix bundle-related error ####
If running 'mo-dev /vagrant' causes errors similar to:
```
/usr/lib/ruby/1.9.1/rubygems/dependency.rb:247:in `to_specs': Could not find bundler (>= 0) amongst [bundler-unload-1.0.2, executable-hooks-1.3.2, gem-wrappers-1.2.7, rubygems-bundler-1.4.4, rvm-1.11.3.9] (Gem::LoadError)
from /usr/lib/ruby/1.9.1/rubygems/dependency.rb:256:in `to_spec'
from /usr/lib/ruby/1.9.1/rubygems.rb:1231:in `gem'
from /usr/local/bin/bundle:22:in `<main>'
rake aborted!
cannot load such file -- bundler/setup
...
```
Then fix things by the following procedure:
On the VM:
```
vagrant@vagrant-ubuntu-trusty-64:~$ exit
```
Then on your local machine:
```
~/developer-startup $ vagrant halt
~/developer-startup $ vagrant up
~/developer-startup $ vagrant ssh
```
Then on the VM
```
vagrant@vagrant-ubuntu-trusty-64:~$ gem install bundle
vagrant@vagrant-ubuntu-trusty-64:~$ mo-dev /vagrant
```

#### Ensure RVM is installed on the VM ####

Look at the last line displayed by mo-dev /vagrant. If it is

    RVM installed.  Run: source /home/vagrant/.rvm/scripts/rvm

then setup [RVM][] (and get the correct Ruby version) by running

    vagrant@vagrant-ubuntu-trusty-64:~$ source /home/vagrant/.rvm/scripts/rvm

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
    $ rake

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

Start the Rails server on the VM

    $ moserver

or

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
sense to add some observations, names and images for testing, but I
haven't gotten to it yet.)

Contributing to MO code development
-----------------------------------
To contribute to MO code development, please follow the suggestions in
[developer-workflow.md][].

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

    % vagrant package clean

This will create a package.box file in the developer-startup
directory.  To allow others to use it, this should get uploaded
to http://images.digitalmycology.com and the Vagrantfile should
be updated to reference the new box and checked in.

- - -
[comment]: # (The following are link reference definitions)
[admin-workflow.md]: /admin-workflow.md
[Bundler]: http://bundler.io/
[developer-workflow.md]: /developer-workflow.md/
[PuTTY]: http://www.putty.org/
[RVM]: https://rvm.io/
