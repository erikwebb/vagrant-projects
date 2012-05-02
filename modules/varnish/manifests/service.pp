class varnish::service {
  service { 'varnish':
    ensure  => running,
    enable  => true,
    require => Class['varnish::install'],
  }

  service { 'varnishlog':
    ensure  => running,
    enable  => true,
    require => Class['varnish::install'],
  }

  service { 'varnishncsa':
    ensure  => running,
    enable  => true,
    require => Class['varnish:install'],
  }
}
