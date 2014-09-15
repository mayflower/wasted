class profile::webserver (
  $php  = true,
  $hhvm = false,
) {
  validate_bool($php)
  validate_bool($hhvm)

  contain component::nginx

  if $php {
    contain component::php
  }
  if $hhvm {
    contain component::hhvm
  }
}
