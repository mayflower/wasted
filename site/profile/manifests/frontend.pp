class profile::frontend (
  $compass = false
) {
  anchor { 'profile::frontend::begin': } ->
  anchor { 'profile::frontend::end': }

  if $compass {
    Anchor['profile::frontend::begin'] ->
      class { 'component::compass': } ->
    Anchor['profile::frontend::end']
  }
}
