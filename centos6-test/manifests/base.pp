include epel

# Disable firewall
class { "firewall":
  ensure => "stopped",
}
