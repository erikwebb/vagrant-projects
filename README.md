# README #

## Dependences ##

1. [Vagrant](http://vagrantup.com/)
1. [Veewee](https://github.com/jedi4ever/veewee)

## Setup ##

First, build the Vagrant basebox using Veewee -
``
  vagrant basebox define 'CentOS-6.2-x86_64' 'CentOS-6.2-x86_64-minimal'
  vagrant basebox build CentOS-6.2-x86_64
  vagrant box add ‘CentOS-6.2-x86_64′ ‘CentOS-6.2-x86_64.box’
``

## Todo ##

- Replace MySQL with MariaDB
