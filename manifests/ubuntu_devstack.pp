class ubuntu_devstack {

  # APT
  ## Make sure all apt sources are always up to date
  class { 'apt': } ->

  # augeas will *not* work (quantal cloudimage basebox) if we do not install the ruby lib
  package { 'libaugeas-ruby': }  ->
  class { 'component::php': } ->
  class { 'component::mysql': } ->
  class { 'component::symfony2': }
  # alternatives
  # class { 'component::zend_framework1': }
  # class { 'component::php_vhost': }

  # We need this dependency handling because otherwise we get a dependency cycle with Service['nginx'] and apt
  class { 'nginx': }
}

include ubuntu_devstack
