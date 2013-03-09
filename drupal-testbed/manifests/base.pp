# Web server
include apache

# PHP
include php

exec { "php-xhprof":
  command => "pecl install xhprof-0.9.2",
  require => [ Package["php-devel"] ],
  creates => "/usr/lib64/php/modules/xhprof.so",
  path    => [ "/usr/bin" ],
}

package { "php-pear-Console-Table":
  require => Package["php-pear"],
}

exec { "drush":
  command => "pear install pear.drush.org/drush",
  require => [ Package["php-pear"], Package["php-pear-Console-Table"] ],
  creates => "/usr/share/pear/drush",
  path    => [ "/usr/bin" ],
}

# MySQL
include mysql

# Memcached
include memcached
