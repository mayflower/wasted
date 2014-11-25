class wasted {
  contain profile::packages
  contain profile::database
  contain profile::queue
  contain profile::javascript
  contain profile::frontend
  contain profile::webserver
  contain profile::app
}

node default {
  class { 'profile::sync': } ->
  class { 'profile::custom_hosts': } ->
  class { 'wasted': }

  if $osfamily == 'Debian' {
    class { 'apt':
      require => Class['profile::sync'],
      before  => Class['wasted'],
    }
  } elsif $osfamily == 'RedHat' {
    class { 'yum':
      require => Class['profile::sync'],
      before  => Class['wasted'],
    }
  }
}
