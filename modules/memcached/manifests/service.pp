class memcached::service {
  service { 'memcached':
    ensure  => running,
    enable  => true,
    require => Class['memcached::install'],
  }
}