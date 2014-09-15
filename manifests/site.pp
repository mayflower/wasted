class ubuntu_devstack {

  # APT
  ## Make sure all apt sources are always up to date
  class { 'apt': } ->

  class { 'profile::default': } ->
  class { 'profile::database': } ->
  class { 'profile::queue': } ->
  class { 'profile::javascript': } ->
  class { 'profile::frontend': } ->
  class { 'profile::webserver': } ->
  class { 'profile::app': }
}

include ubuntu_devstack
