class profile::webserver (
  $hhvm = false,
) {

  validate_bool($hhvm)

  anchor { 'profile::webserver::begin': } ->
    class { 'component::php': } ->
    class { 'component::nginx': } ->
  anchor { 'profile::webserver::end': }

  if $hhvm {
    Anchor['profile::webserver::begin'] ->
    class { 'component::hhvm': } ->
    Anchor['profile::webserver::end']
  }
}
