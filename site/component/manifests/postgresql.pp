class component::postgresql (
  $postgres_password = 'root',
  $postgis = false,
  $extensions = [],
  $databases = {}
) {
  validate_string($postgres_password)
  validate_array($extensions)
  validate_hash($databases)

  anchor { 'component::postgresql::begin': } ->
    class { '::postgresql::server':
      postgres_password => $postgres_password
    } ->
  anchor { 'component::postgresql::end': }

  if $postgis {
    Anchor['component::postgresql::begin'] ->
    class { '::postgresql::server::postgis': } ->
    Anchor['component::postgresql::end']
  }

  ensure_resource('package', $extensions, {
    require => Anchor['component::postgresql::begin'],
    before  => Anchor['component::postgresql::end']
  })

  create_resources('::postgresql::server::db', $databases, {
    require => Anchor['component::postgresql::begin'],
    before  => Anchor['component::postgresql::end']
  })
}
