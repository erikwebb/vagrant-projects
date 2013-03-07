# Defaults

File {
  owner   => "root",
  group   => "root",
}

# Repositories
yumrepo { "epel":
  descr      => "Extra Packages for Enterprise Linux 6 - \$basearch",
  mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=\$basearch",
  enabled    => 1,
  gpgcheck   => 1,
  gpgkey     => "https://fedoraproject.org/static/0608B895.txt",
}

# Web server
package { "httpd":
}

service { "httpd":
  ensure => "running",
}

file { "/etc/httpd/httpd.conf":
  source => "/vagrant/files/httpd.conf",
  notify => Service["httpd"],
}

# PHP
package { "php": }

file { "/etc/php.ini":
  source => "/vagrant/files/php.ini",
  notify => Service["httpd"],
}

## Extensions
$php_extensions = [ "php-devel", "php-gd", "php-mbstring", "php-mysql", "php-pdo", "php-pear", "php-pecl-apc", "php-pecl-memcache", "php-xml" ]
package { $php_extensions:
  notify  => Service["httpd"],
  require => Package["php"],
}

file { "/etc/php.d/apc.ini":
  owner   => "root",
  group   => "root",
  source  => "/vagrant/files/apc.ini",
  notify  => Service["httpd"],
  require => Package["php-pecl-apc"],
}

exec { "php-xhprof":
  command => "pecl install xhprof-0.9.2",
  require => [ Package["php-devel"] ],
  creates => "/usr/lib64/php/modules/xhprof.so",
  path    => [ "/usr/bin" ],
}

exec { "drush":
  command => "pear channel-discover pear.drush.org ; pear install drush/drush",
  require => [ Package["php-pear"] ],
  path    => [ "/usr/bin" ],
}

# MySQL
# Percona tools
yumrepo { "percona":
  descr    => "Percona - CentOS \$releasever",
  enabled  => 1,
  baseurl  => "http://repo.percona.com/centos/\$releasever/os/\$basearch/",
  gpgcheck => 1,
  gpgkey   => "http://www.percona.com/downloads/RPM-GPG-KEY-percona",
}

package { "Percona-Server-client-55":
  alias => "mysql",
  require => Yumrepo["percona"],
}
package { "Percona-Server-shared-compat":
  alias => "mysql-libs",
  require => Yumrepo["percona"],
}
package { "Percona-Server-server-55":
  alias => "mysql-server",
  require => Yumrepo["percona"],
}
package { "Percona-Server-shared-55":
  require => Yumrepo["percona"],
}

package { "percona-toolkit":
  require => [ Yumrepo["percona"], Package["Percona-Server-shared-compat"] ],
}

service { "mysql":
  ensure => "running",
  require => Package["Percona-Server-server-55"],
}

file { "/etc/my.cnf":
  source  => "/vagrant/files/my.cnf",
  ensure  => "present",
  notify  => Service["mysql"],
  require => Package["Percona-Server-server-55"],
}

# Memcached
package { "memcached": }

service { "memcached":
  ensure => "running",
  subscribe => [ Package["memcached"], File["/etc/sysconfig/memcached"] ],
}

file { "/etc/sysconfig/memcached":
  ensure => "present",
  source => "/vagrant/files/memcached",
}

# Utilities
package { "htop":
  require => Yumrepo["epel"],
}
package { "innotop":
  require => [ Yumrepo["epel"], Package["Percona-Server-shared-compat"], ],
}
package { "mytop":
  require => [ Yumrepo["epel"], Package["Percona-Server-shared-compat"], ],
}
