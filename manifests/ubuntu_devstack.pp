class ubuntu_devstack {

  # APT
  ## Make sure all apt sources are always up to date
  class { 'apt': } ->

  # augeas will *not* work (quantal cloudimage basebox) if we do not install the ruby lib
  package { 'libaugeas-ruby': }  ->
  class { 'component::php': } ->
  class { 'component::mysql': } ->
  class { 'nginx': }

  # We need this dependency handling because otherwise we get a dependency cycle with Service['nginx']
  Class['component::mysql'] ->
  class { 'component::symfony2': }

  # alternatives
  # Class['component::mysql'] ->
  # class { 'component::zend_framework1': }

  # Class['component::mysql'] ->
  # class { 'component::php_vhost': }
}

include ubuntu_devstack
