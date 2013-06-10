include epel

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

exec { "pecl-update":
  command => "pecl channel-update pecl.php.net",
  path    => [ "/usr/bin", "/bin" ],
  require => Package["php-pear"],
}

exec { "php-xhprof":
  command => "pecl install xhprof-beta",
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

exec { "php-xdebug":
  command => "pecl install xdebug",
  require => [ Package["php-devel"], Package["php-pear"] ],
  creates => "/usr/lib64/php/modules/xdebug.so",
  path    => [ "/usr/bin", "/bin" ],
}

file { "/etc/php.d/xdebug.ini":
  require => Exec["php-xdebug"],
  content => "[xdebug]
zend_extension=/usr/lib64/php/modules/xdebug.so
xdebug.default_enable=1
xdebug.collect_params=2
xdebug.remote_autostart=off
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_host=localhost
xdebug.remote_port=9000
"
}

# Install base Drupal
# include drush
include drupal
drupal::core { "7.22":
  path => "/var/www/html",
}
drush::exec { "drush-devel-download":
  command        => "pm-download devel",
  root_directory => "/var/www/html",
}

file { "/var/www/html/sites/default/files":
  ensure  => "directory",
  mode    => "0775",
  require => Drupal::Core["7.22"],
  recurse => "true",
  group   => "apache",
  owner   => "apache",
}

exec { "drupal-settings-file":
  command => "cp /var/www/html/sites/default/default.settings.php /var/www/html/sites/default/settings.php",
  creates => "/var/www/html/sites/default/settings.php",
  path    => [ "/usr/bin", "/bin" ],
  require => Drupal::Core["7.22"],
}

file { "/var/www/html/sites/default/settings.php":
  group   => "apache",
  owner   => "apache",
  require => [ Package["httpd"], Exec["drupal-settings-file"] ],
}

drush::exec { "drush-site-install":
  command        => "site-install standard --account-name=admin --account-pass=admin --db-url=mysql://drupal:drupal@127.0.0.1/drupal --site-name=\"Drupal Testbed\" --yes",
  root_directory => "/var/www/html",
  require        => [ Drupal::Core["7.22"], Exec["drupal-settings-file"], Service["mysqld"] ],
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
