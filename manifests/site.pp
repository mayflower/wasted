class wasted {
  contain profile::default
  contain profile::database
  contain profile::queue
  contain profile::javascript
  contain profile::frontend
  contain profile::webserver
  contain profile::app
}

node default {
  class { 'apt': } ->
  class { 'wasted': }
}
