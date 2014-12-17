# == Class: nfs::server::service
#
# This Function exists to
#  1. manage the needed services for nfs server
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

class nfs::server::service {

  # services
  if $::nfs::nfs_v4 == true {
    service { $::nfs::server_service_name:
      ensure     => $::nfs::server_service_ensure,
      enable     => $::nfs::server_service_enable,
      hasrestart => $::nfs::server_service_hasrestart,
      hasstatus  => $::nfs::server_service_hasstatus,
      subscribe  => [ Concat[$::nfs::exports_file], Augeas[$::nfs::idmapd_file] ]
    }
    service { $::nfs::server_nfsv4_servicehelper:
      ensure     => $::nfs::server_service_ensure,
      enable     => $::nfs::server_service_enable,
      hasrestart => $::nfs::server_service_hasrestart,
      hasstatus  => $::nfs::server_service_hasstatus,
      subscribe  => [ Concat[$::nfs::exports_file], Augeas[$::nfs::idmapd_file] ]
    }

  } else {
  service { $::nfs::server_service_name:
    ensure     => $::nfs::server_service_ensure,
    enable     => $::nfs::server_service_enable,
    hasrestart => $::nfs::server_service_hasrestart,
    hasstatus  => $::nfs::server_service_hasstatus,
    subscribe  => Concat[$::nfs::exports_file]
    }
  }
}
