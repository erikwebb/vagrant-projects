class apache::service {
  service { 'httpd':
    ensure  => running,
    enable  => true,
    require => Class['apache::install'],
    subscribe => File['/etc/httpd/conf/httpd.conf'],
  }
}