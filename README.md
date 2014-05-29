vagrant_generic_devstack
========================
Generic vagrant box (ubuntu) with php, mysql, composer and nginx and preconfigured vhosts for:
 - Symfony2
 - Zend Framework 1

How to use
==========

Just do a "vagrant up".
r10k will first bootstrap your local Puppet modules and after that the provisioning process will be started.
This might not work if you are using non-Virtualbox providers.

To add this to your project:
```
git subtree add --prefix vagrant git@github.com:Mayflower/vagrant_generic_devstack master  # adds this repository as git subtree
./vagrant/bootstrap.sh
```

Configuration
=============

You may use two files to personalize the Vagrantfile easily:
 - `vagrant_project_config` for project-specific configuration like changing the hostname
   (gets created when running the rake bootstrapping task)
 - `vagrant_personal_config` to customize further for your own needs (be sure to add this to .gitignore)

Recommended Plugins
===================

The config makes use of but does not require:
 - vagrant-cachier (Package file caching)
 - vagrant-hostmanager (/etc/hosts management)

To update vbox guest extensions automatically you can use:
 - vagrant-vbguest
