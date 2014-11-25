node default {

  package { ['rubygems', 'git']:
    ensure        => installed,
    allow_virtual => true,
  } ->

  package { ['deep_merge', 'r10k']:
    ensure   => installed,
    provider => 'gem',
  } ->

  exec { 'r10k-puppetfile-install':
    path    => '/usr/bin:/usr/local/bin',
    command => 'r10k -v info puppetfile install && touch modules/.r10k_stamp',
    cwd     => '/vagrant/vagrant',
    onlyif  => 'test ! -e modules/.r10k_stamp || test modules/.r10k_stamp -ot Puppetfile',
  }

}
