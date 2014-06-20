class profile::default {
  anchor { 'profile::default::begin': } ->
    class { 'component::tools': } ->
  anchor { 'profile::default::end': }
}
