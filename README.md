# developer-startup

Welcome to the Mushroom Observer Developer Startup system!  The purpose of this system is to help software developers setup an environment where they can contribute to the Mushroom Observer code base.  The basic idea is to setup a virtual machine on your personal machine that is configured to serve a test version of the Mushroom Observer website and to access the code.  It has been tested on Macintoshes as well as PCs running either Windows or Ubuntu.  This system does require a reasonably powerful computer probably purchased in the last 3 years.

## Create working Mushroom Observer development environment
- Install VirtualBox: https://www.virtualbox.org/
- Install git: http://git-scm.com/downloads/
 - Note on my Mac I've found the GitHub GUI is very useful, https://central.github.com/mac/latest

- Get ruby 1.9.3 working.  There are three different approaches for this documented here: http://www.ruby-lang.org/en/downloads/
  
  >Personally I use RVM since it gives me the flexibility to leave the default ruby installed by MacOS alone and create different ruby environments.  However, this may be overkill for some and RVM forces you to use the Bash shell to really take advantage of it.  In most cases you will need to have a working version of gcc 4.2 or later working to get ruby 1.9.3 installed.
  
  >To install RVM on my Mac under Mountain Lion I had to do the following:
  - Install gcc 4.2 compiler for rvm/ruby (on Mac that currently involves installing Xcode from the App Store including the Command Line Tools (Preferences => Downloads and install 'Command Line Tools'))
  - Install just rvm: `\curl -L https://get.rvm.io | bash -s stable`
  - Install Homebrew: `ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"`
  - Run `rvm requirements` to get a list of brew requirements to get rvm configured with Ruby 1.9.3.
    For me, this meant:  
````
brew update
brew tap homebrew/dupes
brew install autoconf automake apple-gcc42 libtool pkg-config openssl readline libyaml sqlite libxml2 libxslt libksba
````
  - Now install ruby using RVM: `\curl -L https://get.rvm.io | bash -s stable --ruby` [Perhaps `rvm install 1.9.3` would work just as well]
  - Finally, open a new shell and check the version of ruby with `ruby --version`.  You should get something like: ruby 1.9.3p194 (2012-04-20 revision 35410) [x86_64-darwin11.3.0]
 - Note: If building ruby from source on ubuntu, be sure to install libyaml-dev package first, or psych will not work.

- Get the developer-startup Git project: 
 - % `git clone https://github.com/MushroomObserver/developer-startup.git`
- Go into the resulting directory: % `cd developer-startup`
- If you have bash installed, run the startup script: % `./startup`
 - Otherwise, just run the commands in this file from any command-line tool.
- Wait for a while...
- Test the new machine: % `vagrant ssh`
  - On Windows machines this may require installing an ssh client like Putty.  Attempting to run `vagrant ssh` will give you the parameters you need to give to Putty.
  You have been successful if the final output line is:
    vagrant@lucid32:~$ 

Assuming all of that was successful, you now have a running virtual machine with the MO source code installed, an instance of MySQL and all the goodies to successfully run all the tests and startup a local server (see below).  You access the new machine by being in the developer-startup directory and running `vagrant ssh` or through Putty.  The new instance of MySQL can be accessed with usernames/passwords mo/mo or root/root.

## Run the tests in the new environment
- Go to vagrant machine (`vagrant ssh` or through Putty), then
 - $ `cd /vagrant/mushroom-observer`
 - $ `script/run_tests`

## Which branch?
- The MO project currently (26 July 2014) has two major branches:  
 - production branch, which uses Rails 2.1.1, and is named Master
 - development branch, which uses Rails >= 3.0 and is named ror23.  (As of this writing, we are on Rails 3.0.)
- To use the production branch, please skip to **Start web server** below.

- To use the development branch:
```
git checkout ror23
bundle install
rake db:migrate
rake lang:update
script/run_tests
```

  - Notes:
    - The name of the development branch may change to reflect use of more recent Rails versions.
    - Jason notes: 
 >[P]otentially your particular build of ruby1.9.3 could have adverse effects, too.  (For example, I discovered that I had to have libyaml installed *before* I built ruby1.9.3 or rails wouldn't work.  My notes suggest a couple addtional ubuntu library packages, as well: libcurl4-openssl-dev and libssl-dev
-- but they may only be needed for passenger when deploying on the production server...)
 
## Start web server
- Go to vagrant machine (`vagrant ssh` or through Putty)
- $ `cd /vagrant/mushroom-observer`
- Start the server
 - In the production branch: $ `script/server`
 - In the development branch: $ `rails server`
- In your regular browse, go to http://localhost:3000 
 - Note: one developer reports that port-forwarding required use of port 5656 instead of 3000).

## Create a user in the new instance of MO
- In your regular browse, go to http://localhost:3000/account/signup and create a new account in the new instance of MO.
- Find the verification URL just generated by the new instance of MO.
 - Go to vagrant machine (`vagrant ssh` or through Putty): 
  - $ `grep verify /vagrant/mushroom-observer/log/development.log` and find the url
     - Note: You can also find it by looking in developer-start/mushroom-observer/log/development.log
 - Go to verification URL in your regular browser.

- Have fun!  (Note the initial database, developer-startup/init.sql, just has the admin user and the language stuff.  It probably makes sense to add some observations, names and images for testing, but I haven't gotten to it yet.)

## Edit code
In your developer-startup directory there will be a 'mushroom-observer' directory.  This is a 'shared folder' which is the same as /vagrant/mushroom-observer on the VM.  You can change code here on either machine and it will be picked up by the server on the VM.
