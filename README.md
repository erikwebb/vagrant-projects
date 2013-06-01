# Erik's Vagrant Projects

## Dependencies

1. [Vagrant](http://vagrantup.com/) >= v1.1
2. [Librarian-puppet](http://librarian-puppet.com/)

## Summary

All projects are different types of VMs to work in a Drupal environment. Each is based on the [CentOS 6.4 VM from Puppet Labs](https://github.com/puppetlabs/puppet-vagrant-boxes) (using Puppet, obviously).

To install all the dependent Puppet modules, use librarian-puppet -

    $ librarian-puppet install

## Projects

### CentOS 6 Test

Includes a base CentOS 6 installation.

### Drupal Testbed

Ready-to-use Drupal 7 system based on CentOS 6. This project includes all necessary PHP extensions, Apache, MySQL, and Memcached.

### Load Test

**Note: This VM is configured by default to use 2GB RAM in order to run reasonable load tests.**

Purpose-built for load testing, this installs ab, sysbench, siege, and JMeter by default.

### Zend Server

[Zend Server](https://www.zend.com/en/products/server/) and all of its components are configured in order to run Drupal 7 (or any other LAMP application).
