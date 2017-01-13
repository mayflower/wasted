class component::slim (
  $path    = hiera('path', '/var/www/app_name'),
  $vhost   = hiera('vhost', 'app-name.dev'),
  $env     = hiera('env', 'dev'),
  $docroot = undef,
) {

  $www_root = $docroot ? {
    undef => $path,
    default => "${path}/${docroot}"
  }

  nginx::resource::vhost { $vhost:
    www_root    => $www_root,
    fastcgi     => '127.0.0.1:9000',
    try_files   => ['$uri', '$uri/', '/index.php?$args'],
    location_cfg_append => {
      fastcgi_index => 'index.php',
      fastcgi_param => [
        'SCRIPT_FILENAME $document_root/index.php',
      ]
    },
  }

  nginx::resource::location{ "${vhost}_static":
    location  => '~ ^/(css|images|js)/',
    vhost     => $vhost,
    www_root  => $www_root,
    try_files => ['$uri', '=404']
  }
}
