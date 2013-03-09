class php {
  Package {
    provider => "yum",
    ensure => "installed",
    notify => Service['httpd'],
  }

  package { "php": }

  file { "/etc/php.ini":
    content => template('php/php.ini.erb'),
    notify => Service['httpd'],
  }
  
  # PHP extensions required by Drupal
  Package {
    require => Package['php']
  }
  package { "php-devel": }
  package { "php-gd": }
  package { "php-mbstring": }
  package { "php-mysql": }
  package { "php-pdo": }
  package { "php-pecl-apc": }
  package { "php-pecl-memcache": }
  package { "php-xml": }

  file { "/etc/php.d/apc.ini":
    content => template('php/apc.ini.erb'),
    notify => Service['httpd'],
  }
  file { "/etc/php.d/memcache.ini":
    source => 'puppet:///modules/php/memcache.ini',
    notify => Service['httpd'],
  }

}

