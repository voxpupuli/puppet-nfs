# Function: nfs::functions::bindmount
#
# @summary
# This Function exists to
#  1. manage bindmounts
#
# @param mount_name
#   String. Sets the target directory for the bindmount
#
# @param ensure
#   String. Sets if enabled or not.
#
# @author
# * Daniel Klockenkaemper <mailto:dk@marketing-factory.de>
# * Martin Alfke <tuxmea@gmail.com>
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
