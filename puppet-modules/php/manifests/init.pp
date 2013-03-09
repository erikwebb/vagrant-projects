# == Class: php
#
# Full description of class php here.
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
#  class { php:
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
class php {
  Package {
    provider => "yum",
    ensure => "installed",
    notify => Service['httpd'],
  }
  
  package { "php": }

  file { "/etc/php.ini":
    content => template('php/php.ini.erb'),
    notify => Service['httpd'],
  }
  
  # PHP extensions required by Drupal
  Package {
    require => Package['php']
  }
  package { "php-devel": }
  package { "php-gd": }
  package { "php-mbstring": }
  package { "php-mysql": }
  package { "php-pdo": }
  package { "php-pecl-apc": }
  package { "php-pecl-memcache": }
  package { "php-xml": }

  file { "/etc/php.d/apc.ini":
    content => template('php/apc.ini.erb'),
    notify => Service['httpd'],
  }
  file { "/etc/php.d/memcache.ini":
    source => 'puppet:///modules/php/memcache.ini',
    notify => Service['httpd'],
  }

}

