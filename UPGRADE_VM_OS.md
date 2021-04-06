Upgrading the Operating System for the MO Virtual Machine
=========================================================

This attempts to document the steps in upgrading the operating system
for the MO Virtual Machine.  Since the changes in an OS upgrade are
unpredictable, it is likely that this process with change over time,
but the general steps should remain the same.

1) Update VirtualBox and Vagrant

On Oct 17, 2020 using Ubuntu Bionic Beaver on my laptop, the latest
version of VirtualBox is:

virtualbox-6.1_6.1.14-140239_Ubuntu_bionic_amd64.deb

I installed this over:

virtualbox-6.1_6.1.14-140239_Ubuntu_bionic_amd64.deb

which I had downloaded Mar 14, 2020.

For Vagrant I installed:

vagrant_2.2.10_x86_64.deb

over:

vagrant_2.2.7_x86_64.deb.

2) Verify whether any old boxes still work.  This willd depend on how
many changes and at what those changes have happened to the tools above.

In the current example I was still able to run existing vagrant boxes.

3) Destroy or set aside any old boxes.

I generally just destroy the current box with:

    vagrant destroy

However, this may be a bit risky, but you really should be able to get
back to the old setup if needed and these boxes should not be considered
precious.

4) Update the Vagrantfile

I generally go to the Vagrant Boxes search page on the HashiCorp website
and search for the OS I'm looking for.

At the moment I'm trying to get Ubuntu 20.04 (aka Focal Fossa).  In
the past I have found the Hashicorp boxes work a bit better than the
Ubuntu boxes if they are available.  However, at the moment there only
appears to be an Ubuntu box.  So I'm replacing "hashicorp/bionic64"
with "ubuntu/focal64".

I also switch the box names from the generic names "clean" and "mo"
to "clean-focal" and "mo-focal" to make it potentially easier to go
back to the way it was.  I may keep this naming system going forward
to make transitions like this simpler.

5) Build the "clean" box

In the current case I ran: "vagrant up clean-focal".

For build there were some red warnings/errors related signatures and
checksums.

I was still able to connect using: "vagrant ssh clean-focal"

6) Create "clean" package

In the current case I ran: "vagrant package clean-focal".

This results in a file called package.box.

Ultimately This should be uploaded to images.mushroomobserver.org and
moved to the directory /images/mo with the right ownership (mo:mo) and
permissions (644).

Before doing this you may want to test it locally by changing the
mo.vm.box_url to refer to the local file.  Just remember to
switch it back to the real URL after you have things working.

In the current case I moved package.box to mo-focal.box and update
the variable to point to:

file:///home/nathan/src/developer-startup/mo-focal.box

7) Bring up the vagrant box

Run: vagrant up

This should bring up a version of the box with the new operating system.

Now run: vagrant ssh

This should connect you to the new box.

8) Setup the local build environment

Run: mo-dev /vagrant

This will run bundler and the other bits needed to get the new box
setup to actually run MO.

9) Run the tests

Run: cd /vagrant/mushroom-observer; rails test

If everything is green you great!

If stuff fails now you have to figure out how to fix it.

In the current case I ran into several issues related to the MySQL version
change.  See focal-upgrade branch in mushroom-observer.

10) Don't forget to switch to upload the new box to images.mushroomobserver.org
and update box_url in the Vagrantfile.
