class redis::install {
  package { 'redis':
    ensure => latest,
  }
}