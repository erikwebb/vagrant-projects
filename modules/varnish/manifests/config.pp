class varnish::config {
  file { '/etc/varnish/default.vcl': 
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 0600,
    source  => 'puppet:///modules/varnish/default.vcl',
    require => Class['varnish::install'],
    notify  => Class['varnish::service'],
  }
  
  file { '/etc/sysconfig/varnish': 
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 0600,
    source  => 'puppet:///modules/varnish/sysconfig',
    require => Class['varnish::install'],
    notify  => Class['varnish::service'],
  }
}
