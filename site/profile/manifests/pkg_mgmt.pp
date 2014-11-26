class profile::pkg_mgmt {
  if $osfamily == 'Debian' {
    contain ::apt
  } elsif $osfamily == 'RedHat' {
    contain ::yum
  }
}
