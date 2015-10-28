class component::nodejs (
  $version      = 'stable',
){
  if !($version == 'stable') {
    $make_install = true
  } else {
    $make_install = false
  }
  class { '::nodejs':
    version      => $version,
    make_install => $make_install
  }
  contain '::nodejs'
}
