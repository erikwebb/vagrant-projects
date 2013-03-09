class mysql {
  include common

  # Percona tools
  yumrepo { "percona":
    descr    => "CentOS \$releasever - Percona",
    enabled  => 1,
    baseurl  => "http://repo.percona.com/centos/\$releasever/os/\$basearch/",
    gpgcheck => 1,
    gpgkey   => "http://www.percona.com/downloads/RPM-GPG-KEY-percona",
  }

  package { "Percona-Server-client-55":
    alias => "mysql",
    require => Yumrepo['percona'],
  }
  package { "Percona-Server-shared-compat":
    alias => "mysql-libs",
    require => Yumrepo['percona'],
  }
  package { "Percona-Server-server-55":
    alias => "mysql-server",
    require => Yumrepo['percona'],
  }
  package { "Percona-Server-shared-55":
    require => Yumrepo['percona'],
  }

  package { "percona-toolkit":
    require => [ Yumrepo['percona'], Package['Percona-Server-shared-compat'] ],
  }

  service { "mysql":
    ensure  => "running",
    enable  => true,
    require => Package['Percona-Server-server-55'],
  }

  file { "/etc/my.cnf":
    content => template('mysql/my.cnf.erb'),
    ensure  => "present",
    notify  => Service['mysql'],
  }

  # Monitoring tools
  package { "innotop":
    require => [ Class["common"], Package['Percona-Server-shared-compat'], ],
  }
  package { "mytop":
    require => [ Class["common"], Package['Percona-Server-shared-compat'], ],
  }

}
