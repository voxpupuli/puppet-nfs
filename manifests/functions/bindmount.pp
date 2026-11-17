# @summary Manage bindmounts.
#
# @param mount_name
#   Sets the target directory for the bindmount.
#
# @param ensure
#   Sets if enabled or not.
#
# @param umask
#   Set umask for mount directory creation.
#
# @author
#   * Daniel Klockenkaemper <dk@marketing-factory.de>
#   * Martin Alfke <tuxmea@gmail.com>
#
define nfs::functions::bindmount (
  Optional[String[1]] $mount_name = undef,
  String[1]           $ensure     = 'present',
  Optional[Stdlib::Filemode] $umask = undef,
) {
  nfs::functions::mkdir { $mount_name:
    ensure => $ensure,
    umask  => $umask,
  }
  mount { $mount_name:
    ensure  => $ensure,
    device  => $name,
    atboot  => true,
    fstype  => $nfs::bindmount_fstype,
    options => $nfs::bindmount_options,
    require => Nfs::Functions::Mkdir[$mount_name],
  }
}
