# @summary Install needed packages for NFS clients.
#
# @author
#   * Daniel Klockenkaemper <dk@marketing-factory.de>
#   * Martin Alfke <tuxmea@gmail.com>
#
class nfs::client::package {
  if $nfs::manage_packages {
    if $nfs::client::nfs_v4 {
      if $nfs::effective_nfsv4_client_services != undef and $nfs::manage_client_service {
        $notify_services = Service[keys($nfs::effective_nfsv4_client_services)]
      } else {
        $notify_services = undef
      }
    } else {
      if $nfs::effective_client_services != undef and $nfs::manage_client_service {
        $notify_services = Service[keys($nfs::effective_client_services)]
      } else {
        $notify_services = undef
      }
    }

    if $nfs::effective_client_packages != undef {
      package { $nfs::effective_client_packages:
        ensure => $nfs::client_package_ensure,
        notify => $notify_services,
      }
    }
  }
}
