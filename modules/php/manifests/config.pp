class php::config {
  File {
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 0600,
    require => Class['php::install'],
    notify  => Class['apache::service'],
  }
  file { '/etc/php.ini': 
    source  => 'puppet:///modules/php/php.ini',
  }
  file { '/etc/php.d/apc.ini': 
    source  => 'puppet:///modules/php/apc.ini',
  }
  file { '/etc/php.d/memcache.ini': 
    source  => 'puppet:///modules/php/memcache.ini',
  }
  file { '/etc/php.d/xdebug.ini': 
    source  => 'puppet:///modules/php/xdebug.ini',
  }
}
