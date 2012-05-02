class php::install {
  Package { ensure => latest }
  Exec    { path   => ['/usr/bin', '/bin'] }

  package { 'php': }
  
  $modules  = [ 'php-devel', 'php-gd', 'php-mbstring', 'php-pdo', 'php-xml' ]
  package { $modules: }
  
  $pear     = [ 'php-pear', 'php-pear-Console-Table', 'php-pecl-apc', 'php-pecl-memcache', 'php-pecl-xdebug' ]
  package { $pear: }
  
  exec { 'pecl-uploadprogress':
    command => 'sudo pecl install uploadprogress',
    path    => ['/usr/bin', '/bin'],
    unless  => 'pecl info uploadprogress',
    require => [ Package['php-pear'], Package['php-devel'] ],
  }
  
  exec { 'pecl-xhprof':
    command => 'sudo pecl install xhprof-0.9.2',
    unless  => 'pecl info xhprof',
    require => [ Package['php-pear'], Package['php-devel'] ],
  }

  exec { 'pear-drush-install':
    command => 'sudo pear channel-discover pear.drush.org && sudo pear install drush/drush',
    creates => '/usr/share/pear/drush',
    require => Package['php-pear'],
  }

  exec { 'pear-drush-upgrade':
    command => 'sudo pear upgrade drush/drush',
    onlyif  => 'test -d /usr/share/pear/drush',
    require => Package['php-pear'],
  }
}