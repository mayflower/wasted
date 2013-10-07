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

Recommended Plugins
===================

The config makes use of but does not require:
 - vagrant-cachier (Package file caching)
 - vagrant-hostmanager (/etc/hosts management)
