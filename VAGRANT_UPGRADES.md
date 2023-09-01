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

    vagrant global-status

### 4) Update the Vagrantfile ###

For operating system upgrades, I generally go to the [Vagrant Boxes](https://app.vagrantup.com/boxes/search)
search page on the HashiCorp website and search for the OS I'm looking
for.

When doing an OS upgrade I look first for a Hashicorp box and if I there
isn't one, then I'll look for an Ubuntu one.  In the current
Vagrantfile we're using `ubuntu/focal64`.

For Ruby upgrades, it first looks for the version in the Mushroom Observer repo:

    RUBY_V = File.open("./mushroom-observer/.ruby-version") { |f| f.read }.chomp

so ideally, change the Ruby version number there, first. The number specified in 
the Vagrantfile should match, it's the fallback default.

IMPORTANT: You must either change the box names in the Vagrant file or
destroy any relevant boxes.  Vagrant gets a lot of efficiency by
relying on cached copies of things, so make sure you clean out anything
you can.  You can change `version_date` as a simple way to change the
name of the default box.

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

This results in a file called `package.box`.

Ultimately this should be uploaded to `images.mushroomobserver.org` and
moved to the directory `/data/images/mo` with the right ownership (`mo:mo`)
and permissions (`644`).

Before doing this you may want to test it locally by changing the
`mo.vm.box_url` to refer to the local file.  Just remember to
switch it back to the real URL after you have things working.

In the current case I renamed `package.box` to `mo-focal-2022-06-04.box` and
updated the variable to point to:

    file:///home/nathan/src/developer-startup/mo-focal-2022-06-04.box

### 7) Bring up the vagrant box. ###

Run:

    vagrant up

This should bring up a version of the box with the new configuration.

Now run:

    vagrant ssh

This should connect you to the new box.

### 8) Setup the local build environment. ###

Run:

    mo-dev /vagrant

This will run bundler and the other bits needed to get the new box
setup to actually run MO.

### 9) Run the tests. ###

Run:

    cd /vagrant/mushroom-observer; rails test

If everything is green you great!

If stuff fails now you have to figure out how to fix it.

### 10) Don't forget to update `box_url` in the Vagrantfile, and upload the new box
to `images.mushroomobserver.org`. (You will need an ssh account on that server.) ###

    scp /path/to/your/mo-focal-2022-12-01.box youraccount@images.mushroomobserver.org:/data/images/mo

You may have to first upload it to your own directory, if you don't have permissions for `/data/images/mo`.

    scp /path/to/your/mo-focal-2022-12-01.box youraccount@images.mushroomobserver.org:~/
    
This may take a while. Then move your box to `/data/images/mo`

    cd ~
    sudo mv mo-focal-2022-12-21.box /data/images/mo/mo-focal-2022-12-21.box
    
And change the permissions and ownership, so others can download it:

    cd /data/images/mo
    sudo chown mo:mo mo-focal-2022-12-21.box
    sudo chmod 644 mo-focal-2022-12-21.box
