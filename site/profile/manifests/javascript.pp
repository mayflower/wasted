class profile::javascript (
  $nodejs = false,
  $less   = false
) {
  validate_bool($nodejs)
  validate_bool($less)

  anchor { 'profile::javascript::begin': } ->
  anchor { 'profile::javascript::end': }

  if $nodejs {
    Anchor['profile::javascript::begin'] ->
      class { 'component::nodejs': } ->
    Anchor['profile::javascript::end']
  }

  if $less {
    Class['component::nodejs'] ->
    class { 'component::less': } ->
    Anchor['profile::javascript::end']
  }
}
