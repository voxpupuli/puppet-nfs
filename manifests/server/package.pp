# == Class: nfs::server::package
#
# This Function exists to
#  1. install needed packages for nfs server
#
# === Parameters
#
# TODO: has to be filled
#
# === Examples
#
# TODO: has to be filled
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * Daniel Klockenkämper <mailto:dk@marketing-factory.de>
#

class nfs::server::package {
  package { $::nfs::server_packages:
      ensure => installed
  }
}