class component::zend_framework1 (
  $path = hiera('www_path', '/var/www/application_name'),
  $vhost = hiera('vhost', 'application_name.dev'),
  $env = hiera('env', 'dev'),
) {

  nginx::resource::vhost { $vhost:
    www_root            => "${path}/public",
    fastcgi             => '127.0.0.1:9000',
    location_cfg_append => {
      fastcgi_index => 'index.php',
      fastcgi_param => [
        'SCRIPT_FILENAME $document_root/index.php',
        "APPLICATION_ENV ${env}"
      ]
    },
  }

  nginx::resource::location{ "${vhost}_static":
    location  => '~ ^/(style|images|scripts)/',
    vhost     => $vhost,
    www_root  => "${path}/public",
    try_files => ['$uri', '=404']
  }
}
