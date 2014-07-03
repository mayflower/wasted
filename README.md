# WASTED
**Web Application Stack for Extreme Development**

This is a generic vagrant box (ubuntu) with php, mysql, composer and nginx and preconfigured vhosts for:
 - Symfony2
 - Zend Framework 1

- [Recommended Plugins](#recommended-plugins)
- [How to use](#how-to-use)
- [Contributing](#contributing)

## Recommended Plugins

The config makes use of but does not require:
 - vagrant-cachier (Package file caching)
 - vagrant-hostmanager (/etc/hosts management)

To update vbox guest extensions automatically you can use:
 - vagrant-vbguest

## How to use

Just do a "vagrant up".
r10k will first bootstrap your local Puppet modules and after that the provisioning process will be started.
This might not work if you are using non-Virtualbox providers.

### Note on git-subtree
`git-subtree` was first added to git with 1.7.11 in May 2012. If it isn't available on your machine see
the [installation instructions](https://github.com/git/git/blob/master/contrib/subtree/INSTALL).
All git subtree commands accept a `--squash` flag to squash the subtree commits into one commit.

### Adding to your project
```
git subtree add --prefix vagrant git@github.com:Mayflower/wasted master
./vagrant/bootstrap.sh
```

### Configuration
All configuration happens in the `devstack.yaml` which gets created when running the bootstrap above.
You may add a `local_devstack.yaml` in which you can overwrite configuration in devstack.yaml e.g. when using
different IP or box name.

**TODO** Document devstack.yaml possibilities

### Updating
To update the devstack use:
```
git subtree pull --prefix vagrant git@github.com:Mayflower/wasted master
```

## Contributing
If you have push access to the devstack you may create a new branch directly and then submit a pull request:
```
git subtree push --prefix vagrant git@github.com:Mayflower/wasted $BRANCH_NAME
```

Otherwise please fork the devstack and then create a pull request from your fork:
```
git subtree push --prefix vagrant git@github.com:$YOUR_USER/wasted $BRANCH_NAME
```
