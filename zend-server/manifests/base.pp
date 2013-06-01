yumrepo { "Zend":
  descr    => "Zend Server",
  baseurl  => "http://repos.zend.com/zend-server/6.0/rpm/\$basearch",
  enabled  => 1,
  gpgcheck => 1,
  gpgkey   => "http://repos.zend.com/zend.key",
  require  => Yumrepo["Zend_noarch"],
}

yumrepo { "Zend_noarch":
  descr    => "Zend Server",
  baseurl  => "http://repos.zend.com/zend-server/6.0/rpm/noarch",
  enabled  => 1,
  gpgcheck => 1,
  gpgkey   => "http://repos.zend.com/zend.key",
}

package { "zend-server-php-5.3":
  require => Yumrepo["Zend"],
}

file { "/etc/profile.d/zend.sh":
  content => "PATH=\$PATH:/usr/local/zend/bin
LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/zend/lib",
  mode    => 0755,
}

# Install PHP extensions
$php_extensions = [ "php-5.3-dev-zend-server", "php-5.3-gd-zend-server", "php-5.3-mbstring-zend-server", "php-5.3-pdo-mysql-zend-server",  "php-5.3-uploadprogress-zend-server" ]
package { $php_extensions:
  require => Package["zend-server-php-5.3"],
  notify  => Service["zend-server"],
}

file { "/usr/local/zend/etc/conf.d/uploadprogress.ini":
  content => "extension=uploadprogress.so",
  require => Package["php-5.3-uploadprogress-zend-server"],
}

package { "mod-php-5.3-apache2-zend-server":
  require => Package["zend-server-php-5.3"],
}

service { "zend-server":
  ensure => "running",
  enable => true,
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

# Disable firewall
class { "firewall":
  ensure => "stopped",
}
