class component::apache (
  $php = false,
) {

  anchor { 'component::apache::begin': } ->
    class { '::apache': } ->
  anchor { 'component::apche::end': }

  if $php {
    ::apache::mod { 'proxy': }
    ::apache::mod { 'proxy_fcgi': }
  }

}
