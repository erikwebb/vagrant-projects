# README

## Dependences

1. [Vagrant](http://vagrantup.com/)

## Summary

All projects are different types of VMs to work in a Drupal environment. Each is based on the [CentOS 6.3 VM from Puppet Labs](https://github.com/puppetlabs/puppet-vagrant-boxes) (using Puppet, obviously).

**In order to install the dependent Puppet modules, please download the [Librarian Puppet](https://github.com/rodjek/librarian-puppet) dependency manager.**

## Projects

### CentOS 6 Test

Includes a base CentOS 6 installation.

### Drupal Testbed

Ready-to-use Drupal 7 system based on CentOS 6. This project includes all necessary PHP extensions, Apache, Percona Server 5.5, and Memcached.

### Load Test

**Note: This VM is configured by default to use 2GB RAM in order to run reasonable load tests.**

Purpose-built for load testing, this installs ab, sysbench, siege, and JMeter by default.

### Zend Server

[Zend Server](https://www.zend.com/en/products/server/) and all of its components are configured in order to run Drupal 7 (or any other LAMP application).