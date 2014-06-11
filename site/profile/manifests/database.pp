class profile::database (
  $mysql      = true,
  $postgresql = false
) {
  validate_bool($mysql)
  validate_bool($postgresql)

  anchor { 'profile::database::begin': } ->
  anchor { 'profile::database::end': }

  if $mysql {
    Anchor['profile::database::begin'] ->
    class { 'component::mysql': } ->
    Anchor['profile::database::end']
  }

  if $postgresql {
    Anchor['profile::database::begin'] ->
    class { 'component::postgresql': } ->
    Anchor['profile::database::end']
  }
}
