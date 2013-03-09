include common

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

package { "mod-php-5.3-apache2-zend-server":
  require => Package["zend-server-php-5.3"],
}

service { "zend-server":
  ensure => "running",
  enable => true,
}

## Install MySQL
include mysql
