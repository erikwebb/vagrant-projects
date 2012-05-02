class apache::config {
  # Ensure .htaccess files will work
  # augeas { 'AllowOverride':
  #   context => '/files/etc/httpd/conf/httpd.conf',
  #   changes => 'set Directory[arg =~ regexp(".*/var/www/html.*")]/*[self::directive="AllowOverride"]/arg "All"',
  # }
  
  file { '/etc/httpd/conf/httpd.conf':
    ensure => present,
  }
}