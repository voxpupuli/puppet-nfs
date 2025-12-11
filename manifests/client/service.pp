# @summary Manage the needed services for NFS clients.
#
# @author
#   * Daniel Klockenkaemper <dk@marketing-factory.de>
#   * Martin Alfke <tuxmea@gmail.com>
#
class nfs::client::service {
  if $nfs::client::nfs_v4 {
    $create_services = $nfs::effective_nfsv4_client_services

    if $nfs::server_enabled {
      $subscription = [Concat[$nfs::exports_file], Augeas[$nfs::idmapd_file]]
    } else {
      if ($nfs::client_rpcbind_config != undef)
      and ($nfs::client_rpcbind_optname != undef)
      and ($nfs::client_rpcbind_opts != undef) {
        $subscription = [
          Augeas[$nfs::idmapd_file],
          Augeas[$nfs::defaults_file],
          Augeas[$nfs::client_rpcbind_config],
        ]
      } else {
        $subscription = [
          Augeas[$nfs::idmapd_file],
          Augeas[$nfs::defaults_file],
        ]
      }
    }
  } else {
    $create_services = $nfs::effective_client_services

    if $nfs::server_enabled {
      $subscription = [Concat[$nfs::exports_file]]
    } else {
      $subscription = undef
    }
  }

  $service_defaults = {
    ensure     => running,
    enable     => $nfs::client_services_enable,
    hasrestart => $nfs::client_services_hasrestart,
    hasstatus  => $nfs::client_services_hasstatus,
    subscribe  => $subscription,
  }

  if $create_services != undef and $nfs::manage_client_service {
    create_resources('service', $create_services, $service_defaults )
  }
}
