class component::mongodb (
  $databases = {}
) {
  anchor { 'component::mongodb::start': } ->
    class {'::mongodb::globals':
      manage_package_repo => true,
    } ->
    class {'::mongodb::server':
      auth => true
    } ->
  anchor { 'component::mongodb::end': }

  create_resources('::mongodb::db', $databases, {
    require => Anchor['component::mongodb::start'],
    before  => Anchor['component::mongodb::end']
  })
}
