class profile::webserver (
  $php  = true,
  $hhvm = false,
) {

  validate_bool($hhvm)

  anchor { 'profile::webserver::begin': } ->
    class { 'component::nginx': } ->
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
