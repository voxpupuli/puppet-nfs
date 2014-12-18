# == Function: nfs::functions::bindmount
#
# This Function exists to
#  1. manage bindmounts
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

define nfs::functions::bindmount (
  $mount_name = undef,
  $ensure = 'present'
) {
  nfs::functions::mkdir { $mount_name: }
  mount { $mount_name:
    ensure  => $ensure,
    device  => $name,
    atboot  => true,
    fstype  => 'none',
    options => 'rw,bind',
    require => Nfs::Functions::Mkdir[$mount_name]
  }
}
