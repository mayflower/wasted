node default {

  package { ['ruby', 'git']:
    ensure        => installed,
    allow_virtual => true,
  } ->

  package { ['deep_merge', 'r10k']:
    ensure   => installed,
    provider => 'gem',
  } ->

  exec { 'r10k-puppetfile-install':
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    command => 'r10k -v info puppetfile install && touch modules/.r10k_stamp',
    cwd     => '/vagrant/vagrant',
    onlyif  => 'test ! -e modules/.r10k_stamp || test modules/.r10k_stamp -ot Puppetfile',
  } ->

  augeas { 'remove-deprecated-templatedir-parameter':
    context => '/files/etc/puppet/puppet.conf/main',
    changes => [
      'rm templatedir',
    ],
  }
}
