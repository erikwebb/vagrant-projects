class {'apache': }

class { 'mysql::server':
	config_hash => { 'root_password' => '' }
}

mysql::db { 'mydb':
	user     => 'myuser',
	password => 'mypass',
	host     => 'localhost',
	grant    => ['all'],
}
