class component::nginx (
  $vhosts = {},
  $locations = {},
) {

  validate_hash($vhosts)
  validate_hash($locations)

  anchor { 'component::nginx::begin': } ->
    class { '::nginx': } ->
  anchor { 'component::nginx::end': }

  create_resources('::nginx::resource::vhost', $vhosts)
  create_resources('::nginx::resource::location', $locations)
}
