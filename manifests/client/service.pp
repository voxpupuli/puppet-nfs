# == Class: nfs::client::service
#
# This Function exists to
#  1. manage the needed services for nfs clients
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

class nfs::client::service {

  if $::nfs::client::nfs_v4 {
    $service_defaults = {
      ensure     => running,
      enable     => true,
      hasrestart => $::nfs::client_services_hasrestart,
      hasstatus  => $::nfs::client_services_hasstatus,
      subscribe  => [ Concat[$::nfs::exports_file], Augeas[$::nfs::idmapd_file] ]
    }
    create_resources('service', $::nfs::effective_nfsv4_client_services, $service_defaults )
  } else {
    $service_defaults = {
      ensure     => running,
      enable     => true,
      hasrestart => $::nfs::client_services_hasrestart,
      hasstatus  => $::nfs::client_services_hasstatus,
      subscribe  => [ Concat[$::nfs::exports_file] ]
    }
    create_resources('service', $::nfs::effective_client_services, $service_defaults )
  }
}
