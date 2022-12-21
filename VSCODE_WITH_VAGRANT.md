Setting up VSCode to work on Vagrant
=========================================================

For developers who happen to be using VSCode. The goal here is to be working on the code *inside* the Vagrant box, so your localhost will reflect the code you're editing.

First, install the VSCode extension **Remote - SSH**. Once it's installed, there should be a blue button in the far lower left corner of the VSCode window, with a symbol like `><`.

Once that's installed, in a separate shell window, bring the Vagrant machine up:

    $ vagrant up

Get the SSH config for the Vagrant box on your machine. Type this:

    $ vagrant ssh-config

Copy the output that appears, something like this. You'll need to paste it in VS Code.

    Host mo-focal-2022-12-01
      HostName 127.0.0.1
      User vagrant
      Port 2222
      UserKnownHostsFile /dev/null
      StrictHostKeyChecking no
      PasswordAuthentication no
      IdentityFile /Users/<you!>/.vagrant.d/boxes/mo-focal-2022-12-01/0/virtualbox/vagrant_private_key
      IdentitiesOnly yes
      LogLevel FATAL

Switch back to VSCode. Click that `><` blue button in the bottom left, and select `Remote-ssh: Open configuration file`. I use the config located here:

    /Users/<you!>/.ssh/config

Paste the config you just copied into `config`. You can rename the `Host` in the first line you pasted, to whatever you like.

If there are other hosts you want to keep, don't delete them. Save the file and close.

That's it! Now, the Vagrant `Host` you just pasted and maybe renamed will be available for connection. Click on the same blue icon in the lower left corner of VSCode, and `Connect Current Window to Host`. Pick the Vagrant host, and navigate to the folder for MO.

Thanks to [Andrés Lopez](https://medium.com/@lopezgand/connect-visual-studio-code-with-vagrant-in-your-local-machine-24903fb4a9de) for the tutorial.

# Running Rubocop in VS Code #

The Ruby-Rubocop extension can auto-correct and format code on save, and highlight suggested Rubocop changes.

#### Install the VSCode Ruby-Rubocop extension ####

In VSCode
- Click the extensions icon (on the LH side)
- Install Ruby-Rubocop (and any other relevant extensions)
- For Ruby-Rubocop (and other relevant extensions) click “Install in SSH: <host>”

## Ruby-Rubocop Settings ##

This tells Rubocop to run the version we're using in the `Gemfile`, and the config in `.rubocop.yml`.

In VS Code:
- Click `⌘,` or go to Settings
- click Extensions icon
- select ruby-rubocop
- in the right panel, select the click gear icon, Extension Settings

### Set the file path to our Rubocop configuration YML ###
	
Since it's at the root:
	`/.rubocop.yml` 

### Set the `ruby.rubocop.executePath` ###
    
Rubocop is constantly updated, so this needs to be the currently installed gem. In Terminal, from inside the vagrant box, you can find its path:
```
vagrant@ubuntu-focal:/vagrant/mushroom-observer$ bundle info rubocop
```
This should return:
```
  * rubocop (1.39.0)
	Summary: Automatic Ruby code style checking tool.
	Homepage: https://github.com/rubocop/rubocop
	Documentation: https://docs.rubocop.org/rubocop/1.39/
	Source Code: https://github.com/rubocop/rubocop/
	Changelog: https://github.com/rubocop/rubocop/blob/master/CHANGELOG.md
	Bug Tracker: https://github.com/rubocop/rubocop/issues
	Path: /home/vagrant/.rvm/gems/ruby-3.1.2/gems/rubocop-1.39.0
	Reverse Dependencies: 
		rubocop-graphql (0.14.3) depends on rubocop (>= 0.87, < 2)
		rubocop-performance (1.14.0) depends on rubocop (>= 1.7.0, < 2.0)
		rubocop-rails (2.14.2) depends on rubocop (>= 1.7.0, < 2.0)
```
What you need is the above "Path" plus `/exe/`
									   
	/home/vagrant/.rvm/gems/ruby-3.1.2/gems/rubocop-1.39.0/exe/
