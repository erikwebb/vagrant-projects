class varnish::install {
  package { 'varnish-release':
    provider => 'rpm',
    ensure => installed,
    source => 'http://repo.varnish-cache.org/redhat/varnish-3.0/el5/noarch/varnish-release-3.0-1.noarch.rpm',
  }

  package { 'varnish':
    ensure => latest,
    require => Package['varnish-release'],
  }
}