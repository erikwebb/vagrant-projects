class percona::install {
  package { 'percona-release':
    provider  => 'rpm',
    ensure    => installed,
    source    => 'http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm',
  }

  Package { 
    ensure  => latest,
    require => Package['percona-release'],
  }

  package { 'Percona-Server-server-55': }
  package { 'Percona-Server-client-55': }
  package { 'Percona-Server-shared-compat': }
}