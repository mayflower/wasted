class component::php {

  anchor { 'component::php::begin': }         ->
    class { '::php': }                        ->
    class { '::php::cli': }                   ->
    class { '::php::dev': }                   ->
    class { '::php::fpm': }                   ->
    class { '::php::pear': }                  ->
    class { '::php::composer': }              ->
    class { '::php::composer::auto_update': } ->
  anchor { 'component::php::end': }

  # FIXME: for deep merging support we need a explicit hash lookup instead of automatic parameter lookup
  #        (https://tickets.puppetlabs.com/browse/HI-118)
  $extensions =  hiera_hash('component::php::extensions', {})
  create_resources('::php::extension', $extensions, {
    ensure  => latest,
    require => Class['::php::pear'],
    before  => Anchor['component::php::end']
  })
}
