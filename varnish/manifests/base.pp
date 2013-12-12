include epel

# Disable firewall
class { "firewall":
  ensure => "stopped",
}

# Install Varnish yum repo
package { "varnish-release":
  provider => "rpm",
  source   => "http://repo.varnish-cache.org/redhat/varnish-3.0/el6/noarch/varnish-release/varnish-release-3.0-1.el6.noarch.rpm",
}

# Install and configure Varnish
package { "varnish":
  require => Package["varnish-release"],
}
service { "varnish":
  ensure  => "running",
  require => Package["varnish"],
}

# Install application tools
package { [ "httpd", "php" ]: }
service { "httpd":
  ensure  => "running",
  require => Package["httpd"],
}

