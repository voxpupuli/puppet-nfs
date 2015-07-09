# == Class: nfs::client::package
#
# This Function exists to
#  1. install needed packages for nfs clients
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

class nfs::client::package {

  if $::nfs::effective_client_packages != undef {
    package { $::nfs::effective_client_packages:
        ensure => installed
    }
  }
}