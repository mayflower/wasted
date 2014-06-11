class profile::webserver {

  anchor { 'profile::webserver::begin': } ->
    class { 'component::php': } ->
    class { 'component::nginx': } ->
  anchor { 'profile::webserver::end': }
}
