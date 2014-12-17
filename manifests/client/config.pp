# == Class: nfs::client::service
#
# This Function exists to
#  1. configure nfs as a client
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

class nfs::client::config {

  if $nfs::nfs_v4 == true {
    if $nfs::defaults_file != undef {
      augeas { $nfs::defaults_file:
        context => "/files/${nfs::defaults_file}",
        changes => $nfs::client_idmapd_setting
      }
    }
    if $nfs::idmapd_file != undef {
      augeas { $nfs::idmapd_file:
        context => "/files/${nfs::idmapd_file}/General",
        lens    => 'Puppet.lns',
        incl    => $nfs::idmapd_file,
        changes => ["set Domain ${nfs::client::debian::nfs_v4_idmap_domain}"];
      }
    }
  }
}
