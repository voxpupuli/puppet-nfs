# @param ensure
#   Controls if the managed resources shall be `present` or `absent`.
#
#   If set to `absent`:
#   * The managed software packages are being uninstalled.
#   * Any traces of the packages will be purged as good as possible. This may include existing configuration files.
#     The exact behavior is provider dependent.
#   * System modifications (if any) will be reverted as good as possible (e.g. removal of created users, services,
#     changed log settings, ...).
#   * This is thus destructive and should be used with care.
#
# @param server_enabled
#   If set to `true`, this module will configure the node to act as a NFS server.
#
# @param client_enabled
#   If set to `true`, this module will configure the node to act as a client server, you can use the exported mount
#   resources from configured servers.
#
# @param storeconfigs_enabled
#   If set to `false`, this module will not export any resources as storeconfigs.
#
# @param nfs_v4
#   If set to `true`, this module will use NFS version 4 for exporting and mounting NFS resources.
#
# @param nfs_v4_client
#   If set to `true`, this module will use NFS version 4 for mounting NFS resources.
#   If set to `false` it will use NFS version 3 to mount NFS resources.
#
# @param exports_file
#   It defines the location of file with the NFS export resources used by the NFS server.
#
# @param idmapd_file
#   It defines the location of the file with the idmapd settings.
#
# @param defaults_file
#   It defines the location of the file with the NFS settings.
#
# @param manage_packages
#   It defines if the packages should be managed through this module.
#
# @param server_packages
#   It defines the packages needed to be installed for acting as a NFS server.
#
# @param server_package_ensure
#   It defines the packages state - any of `present`, `installed`, `absent`, `purged`, `held`, `latest`.
#
# @param client_packages
#   It defines the packages needed to be installed for acting as a NFS client
#
# @param client_package_ensure
#   It defines the packages state - any of `present`, `installed`, `absent`, `purged`, `held`, `latest`.
#
# @param manage_server_service
#   Defines if module should manage server_service.
#
# @param manage_server_servicehelper
#   Defines if module should manage server_servicehelper.
#
# @param manage_client_service
#   Defines if module should manage client_service.
#
# @param server_service_name
#   It defines the servicename of the NFS server service.
#
# @param server_service_ensure
#   It defines the service parameter ensure for NFS server services.
#
# @param server_service_enable
#   It defines the service parameter enable for NFS server service.
#
# @param server_service_hasrestart
#   It defines the service parameter hasrestart for NFS server service.
#
# @param server_service_hasstatus
#   It defines the service parameter hasstatus for NFS server service.
#
# @param server_service_restart_cmd
#   It defines the service parameter restart for NFS server service.
#
# @param server_nfsv4_servicehelper
#   It defines the service helper like idmapd for servers configured with NFS version 4.
#
# @param client_services
#   It defines the servicenames need to be started when acting as a NFS client.
#
# @param client_nfsv4_services
#   It defines the servicenames need to be started when acting as a NFS client version 4.
#
# @param client_services_enable
#   It defines the service parameter enable for NFS client services.
#
# @param client_idmapd_setting
#   It defines the Augeas parameter added in @param defaults_file when acting as a NFS version 4 client.
#
# @param client_nfs_fstype
#   It defines the name of the NFS filesystem, when adding entries to `/etc/fstab` on a client node.
#
# @param client_nfs_options
#   It defines the options for the NFS filesystem, when adding entries to `/etc/fstab` on a client node.
#
# @param client_nfsv4_fstype
#   It defines the name of the NFS version 4 filesystem, when adding entries to `/etc/fstab` on a client node.
#
# @param client_nfsv4_options
#   It defines the options for the NFS version 4 filesystem, when adding entries to `/etc/fstab` on a client node.
#
# @param nfs_v4_export_root
#   It defines the location where NFS version 4 exports should be bindmounted to on a server node.
#
# @param nfs_v4_export_root_clients
#   It defines the clients that are allowed to mount NFS version 4 exports and includes the option string.
#
# @param nfs_v4_mount_root
#   It defines the location where NFS version 4 clients find the mount root on a server node.
#
# @param nfs_v4_idmap_domain
#   It defines the name of the idmapd domain setting in @param idmapd_file needed to be set to the same value on a
#   server and client node to do correct uid and gid mapping.
#
# @param nfsv4_bindmount_enable
#   It defines if the module should create a bindmount for the export.
#
# @param client_need_gssd
#   If `true`, sets `NEED_GSSD=yes` in `/etc/defauls/nfs-common`, usable on Debian/Ubuntu.
#
# @param client_gssd_service
#   If `true` enable rpc-gssd service.
#
# @param client_gssd_options
#   Options for rpc-gssd service.
#
# @param client_d9_gssdopt_workaround
#   If enabled, workaround for passing gssd_options which is broken on Debian 9. Usable only on Debian 9.
#
# @param nfs_v4_idmap_localrealms
#   `Local-Realms` option for idmapd.
#
# @param nfs_v4_idmap_cache
#   `Cache-Expiration` option for idmapd. If `0` cache is unused.
#
# @param manage_nfs_v4_idmap_nobody_mapping
#   Enable setting Nobody mapping in idmapd.
#
# @param nfs_v4_idmap_nobody_user
#   `Nobody-User` option for idmapd.
#
# @param nfs_v4_idmap_nobody_group
#   `Nobody-Group` option for idmapd.
#
# @param client_rpcbind_config
#   It defines the location of the file with the rpcbind config.
#
# @param client_rpcbind_optname
#   It defines the name of environment variable that holds the rpcbind config. E.g. OPTIONS for Debian.
#
# @param client_rpcbind_opts
#   Options for rpcbind service.
#
# @param nfs_v4_root_export_ensure
#   It defines the state of the NFS version 4 root export.
#
# @param nfs_v4_root_export_mount
#   It defines the mountpoint of the NFS version 4 root export.
#
# @param nfs_v4_root_export_remounts
#   It defines if the NFS version 4 root export should be remounted.
#
# @param nfs_v4_root_export_atboot
#   It defines if the NFS version 4 root export should be mounted at boot.
#
# @param nfs_v4_root_export_options
#   It defines the options for the NFS version 4 root export.
#
# @param nfs_v4_root_export_bindmount
#   It defines the bindmount of the NFS version 4 root export.
#
# @param nfs_v4_root_export_tag
#   It defines the tag of the NFS version 4 root export.
#
# @param client_gssd_service_name
#   It defines the servicename of the rpc-gssd service.
#
# @param client_services_hasrestart
#   It defines the service parameter hasrestart for NFS client services.
#
# @param client_services_hasstatus
#   It defines the service parameter hasstatus for NFS client services.
#
# @param client_gssdopt_name
#   It defines the name of the gssd option in `/etc/default/nfs-common`.
#
# @see https://github.com/voxpupuli/puppet-nfs#examples Exemples
#
# @author
#   * Daniel Klockenkaemper <dk@marketing-factory.de>
#   * Martin Alfke <tuxmea@gmail.com>
#
class nfs (
  Enum['present', 'absent', 'running', 'stopped', 'disabled'] $ensure                             = 'present',
  Boolean                                                     $server_enabled                     = false,
  Boolean                                                     $client_enabled                     = false,
  Boolean                                                     $storeconfigs_enabled               = true,
  Boolean                                                     $nfs_v4                             = false,
  Boolean                                                     $nfs_v4_client                      = false,
  Stdlib::Absolutepath                                        $exports_file                       = $nfs::params::exports_file,
  Stdlib::Absolutepath                                        $idmapd_file                        = $nfs::params::idmapd_file,
  Optional[Stdlib::Absolutepath]                              $defaults_file                      = $nfs::params::defaults_file,
  Boolean                                                     $manage_packages                    = true,
  Array                                                       $server_packages                    = $nfs::params::server_packages,
  String                                                      $server_package_ensure              = 'installed',
  Array                                                       $client_packages                    = $nfs::params::client_packages,
  String                                                      $client_package_ensure              = 'installed',
  Boolean                                                     $manage_server_service              = true,
  Boolean                                                     $manage_server_servicehelper        = true,
  Boolean                                                     $manage_client_service              = true,
  String                                                      $server_service_name                = $nfs::params::server_service_name,
  Enum['present', 'absent', 'running', 'stopped', 'disabled'] $server_service_ensure              = 'running',
  Boolean                                                     $server_service_enable              = true,
  Boolean                                                     $server_service_hasrestart          = $nfs::params::server_service_hasrestart,
  Boolean                                                     $server_service_hasstatus           = $nfs::params::server_service_hasstatus,
  Optional[String]                                            $server_service_restart_cmd         = $nfs::params::server_service_restart_cmd,
  Optional[Array]                                             $server_nfsv4_servicehelper         = $nfs::params::server_nfsv4_servicehelper,
  Hash                                                        $client_services                    = $nfs::params::client_services,
  Hash                                                        $client_nfsv4_services              = $nfs::params::client_nfsv4_services,
  Boolean                                                     $client_services_enable             = $nfs::params::client_services_enable,
  Boolean                                                     $client_services_hasrestart         = $nfs::params::client_services_hasrestart,
  Boolean                                                     $client_services_hasstatus          = $nfs::params::client_services_hasstatus,
  Array[String]                                               $client_idmapd_setting              = $nfs::params::client_idmapd_setting,
  String                                                      $client_nfs_fstype                  = $nfs::params::client_nfs_fstype,
  String                                                      $client_nfs_options                 = $nfs::params::client_nfs_options,
  String                                                      $client_nfsv4_fstype                = $nfs::params::client_nfsv4_fstype,
  String                                                      $client_nfsv4_options               = $nfs::params::client_nfsv4_options,
  Boolean                                                     $client_need_gssd                   = false,
  Boolean                                                     $client_gssd_service                = false,
  Optional[Hash]                                              $client_gssd_service_name           = $nfs::params::client_gssd_service_name,
  String                                                      $client_gssd_options                = $nfs::params::client_gssd_options,
  String                                                      $client_gssdopt_name                = $nfs::params::client_gssdopt_name,
  Boolean                                                     $client_d9_gssdopt_workaround       = false,
  String                                                      $nfs_v4_export_root                 = '/export',
  String                                                      $nfs_v4_export_root_clients         = "*.${facts['networking']['domain']}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)",
  String                                                      $nfs_v4_mount_root                  = '/srv',
  String                                                      $nfs_v4_idmap_domain                = $nfs::params::nfs_v4_idmap_domain,
  Variant[String, Array]                                      $nfs_v4_idmap_localrealms           = '', # lint:ignore:params_empty_string_assignment
  Integer                                                     $nfs_v4_idmap_cache                 = 0,
  Boolean                                                     $manage_nfs_v4_idmap_nobody_mapping = false,
  String                                                      $nfs_v4_idmap_nobody_user           = $nfs::params::nfs_v4_idmap_nobody_user,
  String                                                      $nfs_v4_idmap_nobody_group          = $nfs::params::nfs_v4_idmap_nobody_group,
  String                                                      $nfs_v4_root_export_ensure          = 'mounted',
  Optional[String]                                            $nfs_v4_root_export_mount           = undef,
  Boolean                                                     $nfs_v4_root_export_remounts        = false,
  Boolean                                                     $nfs_v4_root_export_atboot          = false,
  String                                                      $nfs_v4_root_export_options         = '_netdev',
  Optional[String]                                            $nfs_v4_root_export_bindmount       = undef,
  Optional[String]                                            $nfs_v4_root_export_tag             = undef,
  Boolean                                                     $nfsv4_bindmount_enable             = true,
  Optional[Stdlib::Absolutepath]                              $client_rpcbind_config              = $nfs::params::client_rpcbind_config,
  Optional[String]                                            $client_rpcbind_optname             = $nfs::params::client_rpcbind_optname,
  Optional[String]                                            $client_rpcbind_opts                = undef,
) inherits nfs::params {
  if $server_enabled {
    if $server_nfsv4_servicehelper != undef {
      $effective_nfsv4_client_services = delete($client_nfsv4_services, $server_nfsv4_servicehelper)
    } else {
      $effective_nfsv4_client_services = $client_nfsv4_services
    }

    $effective_client_services = $client_services
    $effective_client_packages = difference($client_packages, $server_packages)
  } else {
    if $client_gssd_service and $client_gssd_service_name != undef {
      $effective_nfsv4_client_services = $client_nfsv4_services + $client_gssd_service_name
    } else {
      $effective_nfsv4_client_services = $client_nfsv4_services
    }

    $effective_client_services = $client_services
    $effective_client_packages = $client_packages
  }

  if $server_enabled {
    class { 'nfs::server': }
  }

  if $client_enabled {
    class { 'nfs::client': }
  }
}
