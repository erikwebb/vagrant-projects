class percona::config {
  # file { '/etc/my.cnf': 
  #   ensure  => present,
  #   owner   => 'root',
  #   group   => 'root',
  #   mode    => 0600,
  #   # source  => 'puppet:///modules/percona/my.cnf',
  #   require => Class['percona::install'],
  #   notify  => Class['percona::service'],
  # }
}