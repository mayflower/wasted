class profile::app (
  $symfony2        = true,
  $php_vhost       = false,
  $standalone_app  = false,
  $zend_framework1 = false,
  $yii1 = false,
  $yii2 = false
) {
  validate_bool($symfony2)
  validate_bool($php_vhost)
  validate_bool($standalone_app)
  validate_bool($zend_framework1)
  validate_bool($yii1)
  validate_bool($yii2)

  # these dangle around for the mean time otherwise causing dependency cycles with nginx, should work (TM)
  if $symfony2 {
    class { 'component::symfony2': }
  }
  if $php_vhost {
    class { 'component::php_vhost': }
  }
  if $standalone_app {
    class { 'component::standalone_app': }
  }
  if $zend_framework1 {
    class { 'component::zend_framework1': }
  }
  if $yii1 {
    class { 'component::yii1': }
  }
  if $yii2 {
    class { 'component::yii2': }
  }
}
