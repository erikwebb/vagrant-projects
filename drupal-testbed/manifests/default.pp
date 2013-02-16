include apache
include php, pear
include mysql::server
include varnish

package { 'php-devel': }

class { 'memcached':
  max_memory => 128,
}

pear::package { "drush":
  version => "5.8.0",
  repository => "pear.drush.org",
}

# php::module { "xdebug": }
# pear::package { "xhprof-0.9.2": }

varnish::instance { "drupal":
  backend      => "127.0.0.1:8080",
  address      => ["127.0.0.1:80"],
  admin_port   => "6082",
  storage      => ["file,/var/varnish/storage1.bin,32M"],
}
