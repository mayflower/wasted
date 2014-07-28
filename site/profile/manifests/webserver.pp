class profile::webserver (
  $type = 'nginx',
  $php  = true,
  $hhvm = false,
) {

  validate_re($type, ['^nginx$', '^apache$'])
  validate_bool($php)
  validate_bool($hhvm)

  anchor { 'profile::webserver::begin': } ->
    class { "component::${type}": } ->
  anchor { 'profile::webserver::end': }

  if $php {
    Anchor['profile::webserver::begin'] ->
    class { 'component::php': } ->
    Anchor['profile::webserver::end']
  }
  if $hhvm {
    Anchor['profile::webserver::begin'] ->
    class { 'component::hhvm': } ->
    Anchor['profile::webserver::end']
  }
}
