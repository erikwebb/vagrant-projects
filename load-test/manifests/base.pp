include epel

## Load testing tools

package { "httpd-tools": }
package { "siege":
  require => Yumrepo["epel"],
}
package { "sysbench":
  require => Yumrepo["epel"],
}

package { "libmemcached": }
package { "java-1.7.0-openjdk": }

exec { "download-jmeter":
  command => "curl http://www.gtlib.gatech.edu/pub/apache/jmeter/binaries/apache-jmeter-2.9.tgz | tar xz -C .",
  cwd     => "/opt",
  creates => "/opt/apache-jmeter-2.9",
  path    => ["/bin", "/usr/bin"],
  require => Package["java-1.7.0-openjdk"],
}

exec { "download-jmeter-plugins":
  command => "curl -O https://jmeter-plugins.googlecode.com/files/JMeterPlugins-1.0.0.zip ; unzip JMeterPlugins-1.0.0.zip",
  cwd     => "/opt/apache-jmeter-2.9/lib",
  creates => "/opt/apache-jmeter-2.9/lib/JMeterPlugins-1.0.0.zip",
  path    => ["/usr/bin"],
  require => Exec["download-jmeter"],
}

exec { "download-jmeter-plugins-libs":
  command => "curl -O https://jmeter-plugins.googlecode.com/files/JMeterPlugins-libs-1.0.0.zip ; unzip  JMeterPlugins-libs-1.0.0.zip -x LICENSE",
  cwd     => "/opt/apache-jmeter-2.9/lib",
  creates => "/opt/apache-jmeter-2.9/lib/JMeterPlugins-libs-1.0.0.zip",
  path    => ["/usr/bin"],
  require => Exec["download-jmeter"],
}

# Enable saving of thread counts
exec { "enable-jmeter-thread-counts":
  command => "perl -pi -e 's/^#jmeter.save.saveservice.thread_counts=false$/jmeter.save.saveservice.thread_counts=true/' /opt/apache-jmeter-2.9/bin/jmeter.properties",
  unless  => "grep 'jmeter.save.saveservice.thread_counts=true' /opt/apache-jmeter-2.9/bin/jmeter.properties",
  path    => ["/bin", "/usr/bin"],
  require => Exec["download-jmeter"],
}

file { "/etc/profile.d/jmeter.sh":
  content => "PATH=\$PATH:/opt/apache-jmeter-2.9/bin",
  mode    => 0755,
}

## Other utilities

package { "htop":
  require => Yumrepo["epel"],
}
