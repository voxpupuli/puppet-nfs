# @summary Manage the needed services for NFS clients.
#
# @author
#   * Daniel Klockenkaemper <dk@marketing-factory.de>
#   * Martin Alfke <tuxmea@gmail.com>
#
class nfs::client::service {
  if $nfs::client::nfs_v4 {
    $create_services = $nfs::effective_nfsv4_client_services

    if $nfs::manage_idmapd and $nfs::idmapd_file {
      $idmap_sub = [Augeas[$nfs::idmapd_file]]
    } else {
      $idmap_sub = []
    }

    if $nfs::server_enabled {
      $subscription = [Concat[$nfs::exports_file]] + $idmap_sub
    } else {
      if $nfs::defaults_file {
        $defaults_sub = [Augeas[$nfs::defaults_file]]
      } else {
        $defaults_sub = []
      }

      if ($nfs::client_rpcbind_config != undef)
      and ($nfs::client_rpcbind_optname != undef)
      and ($nfs::client_rpcbind_opts != undef) {
        $rpcbind_sub = [Augeas[$nfs::client_rpcbind_config]]
      } else {
        $rpcbind_sub = []
      }

      $subscription = $idmap_sub + $defaults_sub + $rpcbind_sub
    }
  } else {
    $create_services = $nfs::effective_client_services

    if $nfs::server_enabled {
      $subscription = [Concat[$nfs::exports_file]]
    } else {
      $subscription = undef
    }
  }

  # rpcbind is shared infrastructure; NFSv3 clients need it for statd/lockd.
  if $nfs::rpcbind_service and !$nfs::client::nfs_v4 {
    ensure_resource('service', $nfs::rpcbind_service, {
      'ensure' => running,
      'enable' => true,
    })
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
