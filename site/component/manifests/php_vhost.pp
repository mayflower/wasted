class component::php_vhost (
  $path = hiera('www_path', '/var/www/application_name'),
  $vhost = hiera('vhost', 'application_name.dev'),
  $env = hiera('env', 'dev'),
) {

  ## create default vhost
  nginx::resource::vhost { 'default_vhost':
    ensure   => present,
    www_root => '/var/www/devstack',
  } ->
  ## create location to direct .php to the fpm pool
  nginx::resource::location { 'devstack-php-rewrite':
    location  => '~ \.php$',
    vhost     => 'default_vhost',
    fastcgi   => 'unix:/tmp/fpm.socket',
    try_files => ['$uri =404'],
    www_root  => '/var/www/devstack',
  }
}
