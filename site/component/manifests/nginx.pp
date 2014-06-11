class component::nginx {
  anchor { 'component::nginx::begin': } ->
    class { '::nginx': } ->
  anchor { 'component::nginx::end': }
}
