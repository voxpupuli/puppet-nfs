# == Function: nfs::functions::nfsv4_bindmount
#
# This Function exists to
#  1. manage bindmounts for nfs4
#
# === Parameters
#
# [*v4_export_name*]
#   String. Sets the target directory for the bindmount
#
# [*bind*]
#   String. Sets the bindmount options.
#
# [*ensure*]
#   String. Sets if mounted or not.
#
# === Examples
#
# This Function should not be called directly.
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

define nfs::functions::nfsv4_bindmount (
  $v4_export_name,
  $bind,
  $ensure = 'mounted',
) {
  $expdir = "${nfs::server::nfs_v4_export_root}/${v4_export_name}"
  nfs::functions::mkdir { $expdir:
    ensure => $ensure,
  }
  mount { $expdir:
    ensure  => $ensure,
    device  => $name,
    atboot  => true,
    fstype  => 'none',
    options => $bind,
    require => Nfs::Functions::Mkdir[$expdir],
  }
}
