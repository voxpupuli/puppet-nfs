# Function: nfs::functions::mkdir
#
# @summary
# This Function exists to
#  1. manage dir creation
#
# @param ensure
#
# @authors
# * Daniel Klockenkaemper <mailto:dk@marketing-factory.de>
# * Martin Alfke <tuxmea@gmail.com>
#
define nfs::functions::mkdir (
  String[1] $ensure = 'present',
) {
  if $ensure != 'absent' {
    exec { "mkdir_recurse_${name}":
      path    => ['/bin', '/usr/bin'],
      command => "mkdir -p ${name}",
      unless  => "test -d ${name}",
    }
  }
}
