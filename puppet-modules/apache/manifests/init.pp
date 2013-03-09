class apache($apache_version = 'latest') {

  package { "httpd":
    provider => "yum",
    ensure => "present",
  }
  
  package { "httpd-devel":
    provider => "yum",
    ensure => "present",
  }
  
  file { "/etc/httpd/conf/httpd.conf":
    content => template('apache/httpd.conf.erb'),
    notify => Service['httpd'],
  }
  
  service { "httpd":
    ensure => "running",
  }

}
