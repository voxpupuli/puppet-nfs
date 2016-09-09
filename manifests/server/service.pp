# == Class: nfs::server::service
#
# This Function exists to
#  1. manage the needed services for nfs server
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

class nfs::server::service {

  if $::nfs::nfs_v4 == true {

    if $::nfs::manage_server_service {
      service { $::nfs::server_service_name:
        ensure     => $::nfs::server_service_ensure,
        enable     => $::nfs::server_service_enable,
        hasrestart => $::nfs::server_service_hasrestart,
        hasstatus  => $::nfs::server_service_hasstatus,
        restart    => $::nfs::server_service_restart_cmd,
        subscribe  => [ Concat[$::nfs::exports_file], Augeas[$::nfs::idmapd_file] ],
      }
    }

    if $::nfs::server_nfsv4_servicehelper != undef and $::nfs::manage_server_servicehelper {
      service { $::nfs::server_nfsv4_servicehelper:
        ensure     => $::nfs::server_service_ensure,
        enable     => $::nfs::server_service_enable,
        hasrestart => $::nfs::server_service_hasrestart,
        hasstatus  => $::nfs::server_service_hasstatus,
        subscribe  => [ Concat[$::nfs::exports_file], Augeas[$::nfs::idmapd_file] ],
      }
    }

  } else {

    if $::nfs::manage_server_service {
      service { $::nfs::server_service_name:
        ensure     => $::nfs::server_service_ensure,
        enable     => $::nfs::server_service_enable,
        hasrestart => $::nfs::server_service_hasrestart,
        hasstatus  => $::nfs::server_service_hasstatus,
        restart    => $::nfs::server_service_restart_cmd,
        subscribe  => Concat[$::nfs::exports_file],
      }
    }

  }
}
