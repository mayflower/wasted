class profile::frontend (
  $compass = false,
  $bower = false,
  $grunt = false
) {
  anchor { 'profile::frontend::begin': } ->
  anchor { 'profile::frontend::end': }

  if $compass {
    Anchor['profile::frontend::begin'] ->
      class { 'component::compass': } ->
    Anchor['profile::frontend::end']
  }

  if $bower {
    Anchor['profile::frontend::begin'] ->
      class { 'component::bower': } ->
    Anchor['profile::frontend::end']
  }

  if $grunt {
    Anchor['profile::frontend::begin'] ->
      class { 'component::grunt': } ->
    Anchor['profile::frontend::end']
  }
}
