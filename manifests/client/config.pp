# == Class: nfs::client::config
#
# This Function exists to
#  1. configure nfs as a client
#
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

class nfs::client::config {

  if $::nfs::client::nfs_v4 {

    if $::nfs::defaults_file != undef {
      augeas { $::nfs::defaults_file:
        context => "/files/${::nfs::defaults_file}",
        changes => $::nfs::client_idmapd_setting,
      }
    }

    if $::nfs::server_enabled == false {
      if $::nfs::idmapd_file != undef {
        augeas { $::nfs::idmapd_file:
        context => "/files/${::nfs::idmapd_file}/General",
        lens    => 'Puppet.lns',
        incl    => $::nfs::idmapd_file,
        changes => ["set Domain ${::nfs::nfs_v4_idmap_domain}"];
        }
      }
    }

  }
}
