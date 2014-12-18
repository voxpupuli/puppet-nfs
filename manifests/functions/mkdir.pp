# == Function: nfs::functions::mkdir
#
# This Function exists to
#  1. manage dir creation
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

define nfs::functions::mkdir () {
  exec { "mkdir_recurse_${name}":
    path    => ['/bin', '/usr/bin'],
    command => "mkdir -p ${name}",
    unless  => "test -d ${name}",
  }
  file { $name:
    ensure  => directory,
    require => Exec["mkdir_recurse_${name}"],
  }
}
