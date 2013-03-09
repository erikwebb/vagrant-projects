# == Class: varnish
#
# Full description of class varnish here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { varnish:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class varnish(
  $listen = 6081,
  $backends = [ { host => "localhost", port => 80 } ],
  $size = 64M,
  $storage = "malloc"
) {

  # Varnish software
  yumrepo { "varnish":
    descr => "Varnish 3.0 for Enterprise Linux 5 - \$basearch",
    enabled => 1,
    baseurl => "http://repo.varnish-cache.org/redhat/varnish-3.0/el5/\$basearch",
    gpgcheck => 0,
  }

  package { "varnish":
    require => Yumrepo['varnish'],
  }

  service { "varnish":
    ensure => 'running',
    require => Package['varnish'],
  }

  service { "varnishncsa":
    ensure => 'running',
    require => Package['varnish'],
  }

  file { '/etc/varnish/default.vcl':
    content => template('varnish/default.vcl.erb'),
    ensure => 'present',
    notify => Service['varnish'],
  }

  file { '/etc/sysconfig/varnish':
    content => template('varnish/varnish.erb'),
    ensure => 'present',
    notify => Service['varnish'],
  }

}

