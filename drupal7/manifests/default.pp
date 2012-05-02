require base

Exec { path => ['/usr/bin', '/bin'], }

include apache, php, redis, mysql
class { 'mysql::server':
  config_hash => { 'root_password' => 'admin' }
}

stage { 'app': require => Stage['main'] }
# Ensure this class is run last so that all services are available  
class { 'drupal': stage => 'app' }

class drupal {
  # Setup Drupal DB
  database { 'drupal':
    ensure  => present,
    charset => 'utf8',
    require => Class['mysql::server'],
  }
  database_user { 'drupal@localhost':
    ensure        => present,
    password_hash => mysql_password('drupal'),
    require       => Class['mysql::server'],
  }
  database_grant { 'drupal@localhost/drupal':
    privileges => ['all'],
  }

  # Install Drupal from Git
  vcsrepo { "/var/www/html":
    ensure   => latest,
    provider => git,
    force    => true,
    owner    => apache,
    group    => apache,
    source   => "http://git.drupal.org/project/drupal.git",
    revision => '7.x',
  }

  # Install Drupal using Drush
  exec { 'drush-site-install':
    command => 'drush --yes site-install --site-name="Vagrant Install" --account-pass="admin" --db-url="mysql://drupal:drupal@localhost/drupal"',
    cwd     => '/var/www/html',
    creates => '/var/www/html/sites/default/settings.php',
    user    => apache,
    require => [ Vcsrepo['/var/www/html'], Class['php'], Class['mysql::server'] ],
  }

  # Retrieve required module
  exec { 'drush-module-redis':
    command => 'drush pm-download redis',
    cwd     => '/var/www/html',
    creates => '/var/www/html/sites/all/modules/redis',
    user    => apache,
    require => [ Vcsrepo['/var/www/html'], Class['php'] ],
  }

  cron { 'drush-cron':
    command => "/usr/bin/drush -r /var/www/html cron",
    user    => apache,
    special => daily,
  }
}