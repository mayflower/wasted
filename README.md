# wasted
**W**​eb
**A**​pplication
**ST**​ack for
**E**​xtreme
**D**​evelopment

## How? Why?

Wasted is a generic and easily customizable vagrant setup for rapidly
setting up development environments for typical web applications developed
at Mayflower. It is based on an Ubuntu 14.04 trusty box and uses Puppet
for configuration management under the hood.

Configuration of vagrant, the wasted manifests and the Puppet modules
through hiera is stripped down and abstracted by a single YAML
configuration file. For instance, setting the hostname of the vagrant
machine, installing a SQL server or specifying PHP environment variables
can all be done in the same file.

Wasted is designed to be merged via `git-subtree` into an existing git
repository containing the application. We think subtree merges work better
than submodules because customizations, if needed, are much easier to commit
because all code is in one repository. On the other hand, subtrees are easy
enough to keep up-to-date, even with custom changes. See below for
instructions.

## Features

All components can be individually turned on or off and we ensure all of
them can be used in any combination desired.

 - Databases
   - MySQL
   - PostgreSQL
   - MongoDB
   - Redis
 - Messaging Queues
   - RabbitMQ
 - Webservers
   - nginx
 - Interpreters
   - PHP5 (CLI, fpm)
   - HHVM
   - NodeJS
 - Frontend Tools
   - less
   - compass
   - bower
   - grunt
 - Web Application Profiles/VHosts
   - Simple PHP VHost
   - Symfony2 application
   - Zend Framework 1 application
   - Yii 1 & 2 application
   - Proxy for standalone application (i.e. NodeJS)

We try to add support for more software. Pull requests or suggestions are
welcome!

## How to get wasted
Switch to the root of your existing git repository and execute the
following commands:

    $ git subtree add --prefix vagrant --squash https://github.com/Mayflower/wasted.git master
    $ ./vagrant/bootstrap.sh

This requires that there is no pre-existing `vagrant` directory.

### Notes on git-subtree
 - `git-subtree` was first added to git with 1.7.11 in May 2012. If it isn't
   available on your machine see the
   [installation instructions](https://github.com/git/git/blob/master/contrib/subtree/INSTALL).
 - All `git-subtree` commands accept a `--squash` flag to squash the
   subtree commits into one commit if you don't want the complete commit
   history of wasted to clutter your projects git log.

## Configuration
All configuration happens in `devstack.yaml` which is created when running
the `bootstrap.sh` script above.

You may add a `local_devstack.yaml` in which you can overwrite
configuration in `devstack.yaml` for configuration related to your local
environment that you don't want to commit to your git repository. This is
for example useful if you use VirtualBox and want to set another IP
address.

**TODO** Document `devstack.yaml`

## Updating
To update wasted use the following command from the root of your git
repository:

    git subtree pull --prefix vagrant --squash https://github.com/Mayflower/wasted.git master

## Usage
Once you merged wasted in your git repository and configured it properly,
just do a `vagrant up`.

After booting the machine, vagrant will call r10k to fetch the needed
Puppet modules from the Puppet Forge. Next, Puppet provisions the machine.

### Additional information for Windows users
 * You have to run `vagrant up` from the vagrant subdirectory
 * You have to edit your `C:\Windows\System32\drivers\etc\hosts` file manually

## Notes on your Local Setup

### Recommended Vagrant Plugins

The `Vagrantfile` configures, but does not require:
 - vagrant-cachier (Package file caching)
 - vagrant-hostmanager (/etc/hosts management)

To update VirtualBox guest extensions automatically you can use:
 - vagrant-vbguest

### LXC
If you are using LXC instead of VirtualBox (preferred) using the excellent
(vagrant-lxc)[https://github.com/fgrehm/vagrant-lxc] provider, you should
have at least LXC 1.0 and a recent kernel (> 3.5) installed.

Make sure a sane network config is configured in `/etc/lxc/default.conf`
because the provider does not support network config. For instance, if you
have libvirt installed and would like its bridge, you could use:

    lxc.network.type = veth
    lxc.network.link = virbr0
    lxc.network.flags = up

Please note that on recent Ubuntu systems, a bridge for LXC called `lxcbr0`
will be created automatically, so you don't have to worry about any network
configs yourself.

## Contributing
For helping in the development of wasted, create a staging directory and
clone the wasted repository directly into a `vagrant` directory.

    mkdir wasted && cd wasted
    git clone git@github.com:Mayflower/wasted vagrant

Now you can hack on wasted code and use git in the vagrant directory as
you would usually do while still retaining the ability to bootstrap and
use it normally.

### Merge changes back from within your project
If changes were made inside the `vagrant` directory in the git repository
of the application and you would like to contribute those, you need to use
`git subtree push`.

If you have push access, you may create a new branch directly and then
submit a pull request:

    git subtree push --prefix vagrant --squash git@github.com:Mayflower/wasted $BRANCH_NAME

Otherwise, fork this repository and then create a pull request from
your fork:

    git subtree push --prefix vagrant --squash git@github.com:$YOUR_USER/wasted $BRANCH_NAME

## Credits

This project is a collaborative effort by Tristan Helmich (@fadenb), Robin
Gloster (@globin) and Franz Pletz (@fpletz) and sponsored by @Mayflower.

