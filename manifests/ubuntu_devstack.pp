class ubuntu_devstack {

  # APT
  ## Make sure all apt sources are always up to date
  class { 'apt': } ->

  # augeas will *not* work (quantal cloudimage basebox) if we do not install the ruby lib
  package { 'libaugeas-ruby': }  ->
  class { 'profile::default': } ->
  class { 'profile::webserver': } ->
  class { 'profile::database': } ->
  class { 'profile::javascript': } ->
  class { 'profile::app': }
}

include ubuntu_devstack
