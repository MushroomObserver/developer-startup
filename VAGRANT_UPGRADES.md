Updating the MO Virtual Machine
=========================================================

This attempts to document the steps in updating the MO Virtual
Machine.  This is needed from time to time to upgrade the operating
system, the version Ruby or various other core components of the VM.

### 1) Update VirtualBox and Vagrant ###

It's recommended that you always update to the latest version of
[VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://developer.hashicorp.com/vagrant/downloads) at the start of this process.

### 2) Destroy or set aside any old boxes. ###

I generally just destroy the current box with:

    vagrant destroy

This may seem a bit risky, but you really should be able to get back
to the old setup if needed (by downloading the previous box from MO)
and these boxes should not be considered precious.

You may also want to check for any other boxes that may be lingering
and could cause issues with:

    vagrant global-status --prune

The `--prune` flag will ensure that the list is current.

### 4) Update the Vagrantfile ###

> [!IMPORTANT]
> You must either change the box names in the Vagrant file or
destroy any relevant boxes.  Vagrant gets a lot of efficiency by
relying on cached copies of things, so make sure you clean out anything
you can.  You can change `version_date` as a simple way to change the
name of the default box.

###### Change the version_date: ######

MO boxes are named by the date they were created. In the Vagrantfile, set 
`version_date` to today's date:

    version_date = "2023-09-01"

###### Choose a box for your desired Linux distribution: ######

For operating system upgrades, I generally go to the [Vagrant Boxes](https://app.vagrantup.com/boxes/search)
search page on the HashiCorp website and search for the OS I'm looking
for.

When doing an OS upgrade I look first for a Hashicorp box and if I there
isn't one, then I'll look for an Ubuntu one.  In the current
Vagrantfile we're using `ubuntu/focal64`. You just have to set the box name
in the Vagrantfile; you don't have to download the box yourself.

    config.vm.box = "ubuntu/focal64"

###### Set .ruby-version (optional): ######

For Ruby upgrades, it first looks for the version in the Mushroom Observer repo:

    RUBY_V = File.open("./mushroom-observer/.ruby-version") { |f| f.read }.chomp

so ideally, change the Ruby version number there, first. The number specified in 
the Vagrantfile should match, it's the fallback default.

    RUBY_V = "3.1.2"

### 5) Build the "clean" box. ###

In the current case I ran:

    vagrant up clean-focal

You can find the current names by looking in the Vagrantfile and searching
for `config.vm.define`.

Currently builds generate a few red warnings/errors related signatures and
checksums, but everything seems to be working correctly.

### 6) Create "clean" package. ###

In the current case I ran:

    vagrant package clean-focal

This results in a file called `package.box`. You can rename this to something 
like `mo-focal-2023-09-01.box`.

Ultimately this should be uploaded to the image server (instructions #11 below.)
But before uploading, you may want to test it locally. 

### 7) Prepare Vagrantfile to test the box ###

Do this by changing the `mo.vm.box_url` to refer to the local file. 
In the current case I commented out the remote url, and added a line pointing the variable to my local copy:

    # mo.vm.box_url = "https://images.mushroomobserver.org/mo-focal-#{version_date}.box"
    mo.vm.box_url = file:///home/nathan/src/developer-startup/mo-focal-2023-09-01.box

Just remember to switch it back to the remote URL in the Vagrantfile after you have things working.

### 8) Bring up the vagrant box. ###

Run:

    vagrant up

This should bring up a version of the box with the new configuration.

Now run:

    vagrant ssh

This should connect you to the new box.

### 9) Setup the local build environment. ###

Run:

    mo-dev /vagrant

This will run bundler and the other bits needed to get the new box
setup to actually run MO.

### 10) Run the tests. ###

Run:

    cd /vagrant/mushroom-observer; rails test

If everything is green you great!

If stuff fails now you have to figure out how to fix it.

### 11) Change Vagrantfile `box_url` back to point to the remote server ###

> [!IMPORTANT]
> Don't forget to update Vagrantfile before uploading the box.
> This url is what enables others to use the box you've just built. 

Either uncomment the original variable definition, or change `mo.vm.box_url` back to something like:

    mo.vm.box_url = "https://images.mushroomobserver.org/mo-focal-#{version_date}.box"

### 12) Upload the new box to `images.mushroomobserver.org`. ###

To upload the box to the image server, you will need an ssh account on that server. 

    scp /path/to/your/mo-focal-2022-12-01.box youraccount@images.mushroomobserver.org:/data/images/mo

You may have to first upload it to your home directory on the server, if you don't have permissions for `/data/images/mo`.

    scp /path/to/your/mo-focal-2022-12-01.box youraccount@images.mushroomobserver.org:~/
    
This may take a while. Then move your box to `/data/images/mo`

    cd ~
    sudo mv mo-focal-2022-12-21.box /data/images/mo/mo-focal-2022-12-21.box
    
And change the permissions and ownership, so others can download it:

    cd /data/images/mo
    sudo chown mo:mo mo-focal-2022-12-21.box
    sudo chmod 644 mo-focal-2022-12-21.box
