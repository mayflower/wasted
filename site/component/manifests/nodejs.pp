class component::nodejs {
  class { '::nodejs':
    version      => 'stable',
    make_install => false
  } ->
  package { 'grunt-cli':
    provider => 'npm'
  } ->
  package { 'bower':
    provider => 'npm'
  }
}
