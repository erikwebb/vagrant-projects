class base::install {
  Package { ensure => latest, }

  # Install EPEL repository
  package { 'epel-release':
    provider => 'rpm',
    source => 'http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm',
  }

  package { 'git': }
  package { 'augeas': }
  package { 'cronie': }
  package { 'ruby-augeas':
    require => Package['epel-release'],
  }

  # Avoid a current Puppet bug requiring the Puppet group to exist
  # See http://projects.puppetlabs.com/issues/9862
  group { 'puppet':
    ensure  => present,
  }
}