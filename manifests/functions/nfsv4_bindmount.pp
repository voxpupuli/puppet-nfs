# @summary Manage bindmounts for NFS v4.
#
# @param v4_export_name
#   Sets the target directory for the bindmount.
#
# @param bind
#   Sets the bindmount options.
#
# @param ensure
#   Sets if mounted or not.
#
# @param umask
#   Set umask for mount directory creation.
#
# @author
#   * Daniel Klockenkaemper <dk@marketing-factory.de>
#   * Martin Alfke <tuxmea@gmail.com>
#
define nfs::functions::nfsv4_bindmount (
  String[1] $v4_export_name,
  String[1] $bind,
  String[1] $ensure = 'mounted',
  Optional[Stdlib::Filemode] $umask = undef,
) {
  $normalize_export_root = regsubst($nfs::server::nfs_v4_export_root, '/$', '')
  $expdir = "${normalize_export_root}/${v4_export_name}"
  nfs::functions::mkdir { $expdir:
    ensure => $ensure,
    umask  => $umask,
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
