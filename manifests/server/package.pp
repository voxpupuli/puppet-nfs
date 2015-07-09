# == Class: nfs::server::package
#
# This Function exists to
#  1. install needed packages for nfs server
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * Daniel Klockenkaemper <mailto:dk@marketing-factory.de>
#

class nfs::server::package {
  package { $::nfs::server_packages:
      ensure => installed
  }
}