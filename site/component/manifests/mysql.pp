class component::mysql (
  $root_password = 'root',
  $databases = {}
) {

  validate_string($root_password)
  validate_hash($databases)

  anchor { 'component::mysql::begin': } ->
    class {'::mysql::client': } ->
    class {'::mysql::server':
      root_password => $root_password
    } ->
  anchor { 'component::mysql::end': }

  create_resources('::mysql::db', $databases, {
    require => Anchor['component::mysql::begin'],
    before  => Anchor['component::mysql::end']
  })
}
