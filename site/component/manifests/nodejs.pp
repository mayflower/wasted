class component::nodejs {
  class { '::nodejs':
    version => 'stable',
  } ->
  package { 'grunt-cli':
    provider => 'npm'
  } ->
  package { 'bower':
    provider => 'npm'
  }
}
