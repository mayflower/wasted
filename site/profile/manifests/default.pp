class profile::default {
  anchor { 'profile::default::begin': } ->
    class { 'component::sync': } ->
    class { 'component::tools': } ->
  anchor { 'profile::default::end': }
}
