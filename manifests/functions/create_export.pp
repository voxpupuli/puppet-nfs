# @summary Manage export creation.
#
# @param clients
#   Sets the clients allowed to mount the export with options.
#
# @param ensure
#   Sets if enabled or not.
#
# @param owner
#   Sets the owner of the exported directory.
#
# @param group
#   Sets the group of the exported directory.
#
# @param mode
#   Sets the permissions of the exported directory.
#
# @param manage_directory
#   Whether or not to manage the directory to be exported.
#
# @author
#   * Daniel Klockenkaemper <dk@marketing-factory.de>
#   * Martin Alfke <tuxmea@gmail.com>
#
define nfs::functions::create_export (
  Variant[String[1], Array[String[1]]] $clients,
  String[1]                            $ensure = 'present',
  Boolean                              $manage_directory = true,
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

    # Create the directory path only if a File resource isn't
    # defined previously AND the $manage_directory boolean is true.
    unless defined(File[$name]) {
      if $manage_directory {
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
}
