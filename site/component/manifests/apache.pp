class component::apache (
  $php = false,
  $vhosts = {},
) {

  validate_bool($php)
  validate_hash($vhosts)

  anchor { 'component::apache::begin': } ->
    class { '::apache':
      default_vhost => false,
    } ->
  anchor { 'component::apche::end': }

  if $php {
    ::apache::mod { 'proxy': }
    ::apache::mod { 'proxy_fcgi': }
  }

  create_resources('::apache::vhost', $vhosts)
}
