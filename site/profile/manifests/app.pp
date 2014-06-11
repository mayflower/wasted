class profile::app (
  $symfony2        = true,
  $php_vhost       = false,
  $zend_framework1 = false
) {
  validate_bool($symfony2)
  validate_bool($php_vhost)
  validate_bool($zend_framework1)

  anchor { 'profile::app::begin': } ->
  anchor { 'profile::app::end': }

  if $symfony2 {
    Anchor['profile::app::begin'] ->
    class { 'component::symfony2': } ->
    Anchor['profile::app::end']
  }
  if $php_vhost {
    Anchor['profile::app::begin'] ->
    class { 'component::php_vhost': } ->
    Anchor['profile::app::end']
  }
  if $zend_framework1 {
    Anchor['profile::app::begin'] ->
    class { 'component::zend_framework1': } ->
    Anchor['profile::app::end']
  }
}
