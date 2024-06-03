# Function: nfs::functions::create_export
#
# @summary
# This Function exists to
#  1. manage export creation
#
# @param clients
#   String or Array. Sets the clients allowed to mount the export with options.
#
# @param ensure
#   String. Sets if enabled or not.
#
# @param owner
#   String. Sets the owner of the exported directory.
#
# @param group
#   String. Sets the group of the exported directory.
#
# @param mode
#   String. Sets the permissions of the exported directory.
#
# @authors
# * Daniel Klockenkaemper <mailto:dk@marketing-factory.de>
# * Martin Alfke <tuxmea@gmail.com>
#
define nfs::functions::create_export (
  Variant[String[1], Array[String[1]]] $clients,
  String[1]                            $ensure = 'present',
  Optional[String[1]]                  $owner  = undef,
  Optional[String[1]]                  $group  = undef,
  Optional[String[1]]                  $mode   = undef,
) {
  if $ensure != 'absent' {
    $line = "${name} ${join(any2array($clients),' ')}\n"

    concat::fragment { $name:
      target  => $nfs::exports_file,
      content => $line,
    }

    unless defined(File[$name]) {
      file { $name:
        ensure                  => directory,
        owner                   => $owner,
        group                   => $group,
        mode                    => $mode,
        selinux_ignore_defaults => true,
      }
    }
  }
}
