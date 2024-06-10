# Function: nfs::functions::nfsv4_bindmount
#
# @summary
# This Function exists to
#  1. manage bindmounts for nfs4
#
# @param v4_export_name
#   String. Sets the target directory for the bindmount
#
# @param bind
#   String. Sets the bindmount options.
#
# @param ensure
#   String. Sets if mounted or not.
#
# @author
# * Daniel Klockenkaemper <mailto:dk@marketing-factory.de>
# * Martin Alfke <tuxmea@gmail.com>
#
define nfs::functions::nfsv4_bindmount (
  String[1] $v4_export_name,
  String[1] $bind,
  String[1] $ensure = 'mounted',
) {
  $normalize_export_root = regsubst($nfs::server::nfs_v4_export_root, '/$', '')
  $expdir = "${normalize_export_root}/${v4_export_name}"
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
