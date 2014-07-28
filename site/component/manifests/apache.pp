class component::apache (
  $php = false,
  $vhosts = {},
  $mods = [],
  $custom_mods = {},
) {

  validate_bool($php)
  validate_hash($vhosts)
  validate_array($mods)
  validate_hash($custom_mods)

  anchor { 'component::apache::begin': } ->
    class { '::apache':
      default_vhost => false,
    } ->
  anchor { 'component::apache::end': }

  if $php {
    ::apache::mod { 'proxy': }
    ::apache::mod { 'proxy_fcgi': }
  }

  create_resources('::apache::vhost', $vhosts)

  # Mods for which a custom class with the prefix apache::mod exists
  $mods_classes = regsubst($mods, '^(.+)$', '::apache::mod::\1')
  Anchor['component::apache::begin'] ->
    class { $mods_classes: } ->
  Anchor['component::apache::end']

  # All other mods are defined resources
  create_resources('::apache::mod', $custom_mods)
}
