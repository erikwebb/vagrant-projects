class drupal::install {
  vcsrepo { '/var/www/html':
    ensure   => latest,
    force    => true,
    owner    => 'apache',
    group    => 'apache',
    provider => git,
    source   => 'http://git.drupal.org/project/drupal.git',
    revision => '7.x',
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
    command => '/usr/bin/mysql -e "CREATE DATABASE `drupal7`;"',
    creates => '/var/lib/mysql/drupal',
    require => Class['mysql'],
  }

  exec { 'drush -y site-install --site-name="Vagrant Install" --db-url=mysql://root@127.0.0.1/drupal --account-pass="admin"':
    cwd     => '/var/www/html',
    creates => '/var/www/html/sites/default/settings.php',
    path    => [ '/usr/bin', '/bin' ],
    returns => 0,
    user    => 'apache',
    require => [
      Class['php'], Exec['mysql-db'], Vcsrepo['/var/www/html']
    ],
  }

  cron { 'drush-cron':
    command => "/usr/bin/drush -r /var/www/html cron",
    user    => apache,
    special => daily,
  }
}