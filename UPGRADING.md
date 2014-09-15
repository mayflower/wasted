UPGRADING
=========

0.1.0
-----
This adds the possibility to have a whole hiera hierarchy.

You have to make some minor changes due to some differences in loading the files.

### Advanced folder structure
Instead of devstack.yaml you have the possibility to define a whole hiera hierarchy as config:
```
:hierarchy:
  - vagrant-cfg/local/%{::environment}/%{::fqdn}
  - vagrant-cfg/local/%{::environment}/%{::hostname}
  - vagrant-cfg/local/%{::environment}/common
  - vagrant-cfg/local/%{::fqdn}
  - vagrant-cfg/local/%{::hostname}
  - vagrant-cfg/local/common
  - vagrant-cfg/'%{::environment}/%{::fqdn}'
  - vagrant-cfg/'%{::environment}/%{::hostname}'
  - vagrant-cfg/'%{::environment}/common'
  - vagrant-cfg/'%{::fqdn}'
  - vagrant-cfg/'%{::hostname}'
  - vagrant-cfg/common
```
