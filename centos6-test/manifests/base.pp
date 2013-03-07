yumrepo { "epel":
  descr      => "Extra Packages for Enterprise Linux 6 - \$basearch",
  mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=\$basearch",
  enabled    => 1,
  gpgcheck   => 1,
  gpgkey     => "https://fedoraproject.org/static/0608B895.txt",
}
