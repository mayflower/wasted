class component::oracle_instantclient {

  apt::source { 'mayflower-obs-oracle-instantclient':
    location    => 'http://download.opensuse.org/repositories/home:/mayflower/xUbuntu_14.04/',
    release     => './',
    repos       => '',
    key         => '9CA70524',
    key_source  => 'http://download.opensuse.org/repositories/home:/mayflower/xUbuntu_14.04/Release.key',
    include_src => false,
  } ->

  package { 'oracle-instantclient':
    ensure => present,
  }
}
