class apache::install {
  package { 'httpd': ensure => latest, }
}