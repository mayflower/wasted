class profile::frontend (
  $compass = false,
  $bower = false,
  $grunt = false
) {
  validate_bool($compass)
  validate_bool($bower)
  validate_bool($grunt)

  if $compass {
    contain component::compass
  }

  if $bower {
    contain component::bower
  }

  if $grunt {
    contain component::grunt
  }
}
