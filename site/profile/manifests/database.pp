class profile::database (
  $mysql      = false,
  $postgresql = false,
  $mongodb    = false,
  $redis      = false,
) {
  validate_bool($mysql)
  validate_bool($postgresql)
  validate_bool($mongodb)
  validate_bool($redis)

  if $mysql {
    contain component::mysql
  }

  if $mongodb {
    contain component::mongodb
  }

  if $postgresql {
    contain component::postgresql
  }

  if $redis {
    contain component::redis
  }
}
