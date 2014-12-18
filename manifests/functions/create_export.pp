# == Function: nfs::functions::create_export
#
# This Function exists to
#  1. manage export creation
#
# === Parameters
#
# TODO: has to be filled
#
# === Examples
#
# TODO: has to be filled
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * Daniel Klockenkämper <mailto:dk@marketing-factory.de>
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