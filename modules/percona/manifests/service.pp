class percona::service {
  service { 'mysql':
    ensure  => running,
    enable  => true,
    require => Class['percona::install'],
  }
}