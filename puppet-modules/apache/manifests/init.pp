class apache {

  package { "httpd":
    provider => "yum",
    ensure => "present",
  }
  
  package { "httpd-devel":
    provider => "yum",
    ensure => "present",
  }
  
  file { "/etc/httpd/conf/httpd.conf":
    content => template("apache/httpd.conf.erb"),
    notify  => Service["httpd"],
    require => Package["httpd"],
  }
  
  service { "httpd":
    ensure => "running",
    enable => true,
    require => Package["httpd"],
  }

}
