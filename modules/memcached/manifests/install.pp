class memcached::install {
  package { 'memcached':
    ensure => latest,
  }
  
  package { 'libmemcached':
    ensure => latest,
  }
}