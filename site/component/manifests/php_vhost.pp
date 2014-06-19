class component::php_vhost (
  $path = hiera('path', '/var/www/app_name'),
  $vhost = hiera('vhost', 'app-name.dev'),
  $env = hiera('env', 'dev'),
) {

  ## create default vhost
  nginx::resource::vhost { $vhost:
    ensure   => present,
    www_root => $path,
  }
  ## create location to direct .php to the fpm pool
  nginx::resource::location { 'devstack-php-rewrite':
    location  => '~ \.php$',
    vhost     => $vhost,
    fastcgi   => '127.0.0.1:9000',
    try_files => ['$uri =404'],
    www_root  => $path,
  }

  if defined(Class['::hhvm']) {
    ## create default vhost
    nginx::resource::vhost { "hhvm.${vhost}":
      ensure   => present,
      www_root => $path,
    }
    ## create location to direct .php to the fpm pool
    nginx::resource::location { 'hhvm-devstack-php-rewrite':
      location  => '~ \.php$',
      vhost     => "hhvm.${vhost}",
      fastcgi   => '127.0.0.1:9090',
      try_files => ['$uri =404'],
      www_root  => $path,
    }
  }
}
