class component::symfony2 (
  $path = '/srv/www/vhosts/app',
  $vhost = 'sf2.example.com',
  $env = 'development',
) {

  $index_file = $env ? {
    /development|dev/ => 'app_dev.php',
    default           => 'app.php'
  }
  $location_index = $env ? {
    /development|dev/ => '(app_dev|app)',
    default           => 'app'
  }

  nginx::resource::vhost { $vhost:
    www_root    => "${path}/web",
    index_files => [index_file],
    try_files   => ['$uri', '@rewriteapp'],
  }

  nginx::resource::location { '@rewriteapp':
    vhost         => $vhost,
    www_root      => "${path}/web",
    rewrite_rules => ["^(.*)\$ /${index_file}/\$1 last"]
  }

  nginx::resource::location { "~ ^/${location_index}\\.php(/|\$)":
    vhost               => $vhost,
    www_root            => "${path}/web",
    fastcgi             => '127.0.0.1:9000',
    fastcgi_split_path  => '^(.+\.php)(/.+)$',
    location_cfg_append => {
      fastcgi_buffer_size       => '128k',
      fastcgi_buffers           => '4 256k',
      fastcgi_busy_buffers_size => '256k',
    }
  }
}
