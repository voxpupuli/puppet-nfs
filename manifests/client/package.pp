# == Class: nfs::client::package
#
# This Function exists to
#  1. install needed packages for nfs clients
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

class nfs::client::package {

  if $::nfs::client::effective_client_packages != undef {
    package { $::nfs::client::effective_client_packages:
        ensure => installed
    }
  }
}