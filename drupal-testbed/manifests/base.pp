# Web server
class { "apache":
  default_mods => false
}
apache::mod { 'alias': }
apache::mod { 'authz_host': }
apache::mod { 'autoindex': }
apache::mod { 'deflate': }
apache::mod { 'dir': }
apache::mod { 'expires': }
apache::mod { 'headers': }
apache::mod { 'log_config': }
apache::mod { 'mime': }
apache::mod { 'negotiation': }
apache::mod { 'rewrite': }
apache::mod { 'setenvif': }
class { 'apache::mod::php': }
class { 'apache::mod::ssl': }

# Drupal-required PHP modules
$puppet_modules = [ "php-mbstring", "php-gd", "php-xml", "php-pdo", "php-mysql", "php-devel" ]
package { $puppet_modules:
  ensure  => "installed",
  notify  => Service["httpd"],
  require => [ Package["httpd"], Class["apache::mod::php"] ],
}

exec { "php-xhprof":
  command => "pecl install xhprof-0.9.2",
  require => [ Package["php-devel"], Package["php-pear"] ],
  creates => "/usr/lib64/php/modules/xhprof.so",
  path    => [ "/usr/bin", "/bin" ],
}

file { "/etc/php.d/xhprof.ini":
  require => Exec["php-xhprof"],
  content => "[xhprof]
extension=xhprof.so
xhprof.output_dir=/tmp
"
}

# Install base Drupal
# include drush
include drupal
drupal::core { "7.22":
  path => "/var/www/html",
}
drush::exec { 'drush-devel-download':
  command        => 'pm-download devel',
  root_directory => '/var/www/html',
}

# MySQL
include mysql
class { "mysql::server":
  config_hash => { "root_password" => "" }
}
mysql::db { "drupal":
  user     => "drupal",
  password => "drupal",
  host     => "localhost",
  grant    => ["all"],
}

# Memcached
class { 'memcached':
  max_memory => '15%'
}

# Disable firewall
class { "firewall":
  ensure => "stopped",
}
