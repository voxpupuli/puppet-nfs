# == Function: nfs::functions::create_export
#
# This Function exists to
#  1. manage export creation
#
# === Parameters
#
# [*clients*]
#   String. Sets the clients allowed to mount the export with options.
#
# [*ensure*]
#   String. Sets if enabled or not.
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

define nfs::functions::create_export (
  $clients,
  $ensure = 'present'
) {
  if $ensure != 'absent' {
    $line = "${name} ${clients}\n"

    concat::fragment { $name:
      target  => '/etc/exports',
      content => $line
    }
  }
}