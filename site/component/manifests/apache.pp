class component::apache {

  anchor { 'component::apache::begin': } ->
    class { '::apache': } ->
  anchor { 'component::apche::end': }

}
