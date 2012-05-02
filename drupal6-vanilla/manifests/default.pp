# Manifest includes
#  - Apache 2.2 web server
#  - Percona 5.5 database server
#  - Varnish 3.0 reverse proxy server
#  - Redis 2.4 caching server
#  - Memcached 1.4 caching server

class drupal {
  require php

  vcsrepo { '/var/www/html':
    ensure   => latest,
    force    => true,
    owner    => 'apache',
    provider => git,
    source   => 'http://git.drupal.org/project/drupal.git',
    revision => '6.x',
  }

  file { '/var/www/html':
    owner => 'apache',
    group => 'apache',
    recurse => true,
    require => Vcsrepo['/var/www/html'],
  }

  exec { 'pear-drush':
    command => 'sudo pear channel-discover pear.drush.org && sudo pear install drush/drush || sudo pear upgrade drush/drush',
    path => ['/usr/bin', '/bin'],
    creates => '/usr/share/pear/drush',
  }

  # Currently unable to use puppetlabs-mysql module
  # TODO Figure out compatibility with Percona packages
#  mysql::db { 'drupal':
#    user => 'drupaluser',
#    password => 'drupal',
#    host => 'localhost',
#    grant => ['all'],
#  }

  # For now, just use direct MySQL queries
  exec { 'mysql-db':
    command => '/usr/bin/mysql -e "CREATE DATABASE `drupal6`;"',
    creates => '/var/lib/mysql/drupal',
    require => Class['mysql'],
  }

  exec { 'drush -y site-install --site-name="Vagrant Install" --db-url=mysql://root@127.0.0.1/drupal --account-pass="admin"':
    cwd => '/var/www/html',
    creates => '/var/www/html/sites/default/settings.php',
    path => [ '/usr/bin', '/bin' ],
    returns => 0,
    require => [Exec['pear-drush'], Exec['mysql-db'], Vcsrepo['/var/www/html']],
    user => 'apache',
  }
}

require base
include apache
include mysql
include varnish
include redis
include memcached
include drupal
