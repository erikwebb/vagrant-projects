class memcached {

  package { "memcached": }
  package { "libmemcached": }

  service { "memcached":
    ensure => "running",
    require => Package['memcached'],
  }

}
