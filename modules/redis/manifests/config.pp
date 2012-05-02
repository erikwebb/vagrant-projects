class redis::config {
  file { '/etc/redis.conf': 
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    source  => 'puppet:///modules/redis/redis.conf',
    require => Class['redis::install'],
    notify  => Class['redis::service'],
  }
}