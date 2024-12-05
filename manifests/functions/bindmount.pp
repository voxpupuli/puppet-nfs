# @summary Manage bindmounts.
#
# @param mount_name
#   Sets the target directory for the bindmount.
#
# @param ensure
#   Sets if enabled or not.
#
# @author
#   * Daniel Klockenkaemper <dk@marketing-factory.de>
#   * Martin Alfke <tuxmea@gmail.com>
#
define nfs::functions::bindmount (
  Optional[String[1]] $mount_name = undef,
  String[1]           $ensure     = 'present',
) {
  nfs::functions::mkdir { $mount_name:
    ensure => $ensure,
  }
  mount { $mount_name:
    ensure  => $ensure,
    device  => $name,
    atboot  => true,
    fstype  => 'none',
    options => 'rw,bind',
    require => Nfs::Functions::Mkdir[$mount_name],
  }
}
