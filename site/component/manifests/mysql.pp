class component::mysql (
  $db_name = 'dev',
  $db_user = 'dev',
  $db_pw   = 'dev',
) {

  anchor { 'component::mysql::begin': } ->
    class {'::mysql::client': } ->
    class {'::mysql::server': } ->
    mysql::db { $db_name:
      user     => $db_user,
      password => $db_pw,
      host     => 'localhost',
      grant    => ['ALL'],
    } ->
  anchor { 'component::mysql::end': }
}
