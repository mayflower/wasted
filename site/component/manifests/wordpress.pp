class component::wordpress (
  $path             = hiera('path', '/var/www/app_name'),
  $vhost            = hiera('vhost', 'app-name.dev'),
  $vhost_port       = 80,
  $ssl              = false,
  $ssl_cert_dir    = '/etc/ssl/certs',
  $ssl_key_dir     = '/etc/ssl/private'
) {
  if $ssl {
    exec {'create_self_signed_sslcert':
      command => "openssl req -newkey rsa:2048 -nodes -keyout ${ssl_key_dir}/${vhost}.key -x509 -days 365 -out ${ssl_cert_dir}/${vhost}.crt -subj '/CN=${vhost}'",
      creates => ["${ssl_key_dir}/${vhost}.key", "${ssl_cert_dir}/${vhost}.crt"],
      path    => ["/usr/bin", "/usr/sbin"],
      before  => Nginx::Resource::Vhost["${vhost}-${vhost_port}-wordpress"]
    }
  }
  ## create vhost for Wordpress
  nginx::resource::vhost { "${vhost}-${vhost_port}-wordpress" :
    ensure              => present,
    server_name         => [$vhost],
    ssl                 => $ssl,
    ssl_cert            => "${ssl_cert_dir}/${vhost}.crt",
    ssl_key             => "${ssl_key_dir}/${vhost}.key",
    www_root            => $path,
    try_files           => ['$uri $uri/ /index.php?q=$uri&$args'],
    listen_port         => $vhost_port,
  }
  ## create location to direct .php to the fpm pool
  nginx::resource::location { 'wasted-php-rewrite':
    location  => '~ \.php$',
    vhost     => "${vhost}-${vhost_port}-wordpress",
    ssl       => $ssl,
    fastcgi   => '127.0.0.1:9000',
    try_files => ['$uri $uri/ /index.php?q=$uri&$args'],
    www_root  => $path,
  }
}