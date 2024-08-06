# Class: nfs::init
#
# @param ensure
#   String. Controls if the managed resources shall be <tt>present</tt> or
#   <tt>absent</tt>. If set to <tt>absent</tt>:
#   * The managed software packages are being uninstalled.
#   * Any traces of the packages will be purged as good as possible. This may
#     include existing configuration files. The exact behavior is provider
#     dependent. Q.v.:
#     * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
#     * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   * System modifications (if any) will be reverted as good as possible
#     (e.g. removal of created users, services, changed log settings, ...).
#   * This is thus destructive and should be used with care.
#   Defaults to <tt>present</tt>.
# @param server_enabled
#   Boolean. If set to <tt>true</tt>, this module will configure the node
#   to act as a nfs server.
# @param client_enabled
#   Boolean. If set to <tt>true</tt>, this module will configure the node
#   to act as a client server, you can use the exported mount resources
#   from configured servers.
# @param storeconfigs_enabled
#   Boolean. If set to <tt>false</tt>, this module will not export any
#   resources as storeconfigs. Defaults to <tt>true</tt>.
# @param nfs_v4
#   Boolean. If set to <tt>true</tt>, this module will use nfs version 4
#   for exporting and mounting nfs resources.
# @param nfs_v4_client
#   Boolean. If set to <tt>true</tt>, this module will use nfs version 4
#   for mounting nfs resources. If set to <tt>false</tt> it will use nfs
#   version 3 to mount nfs resources. It defaults to the setting of @param nfs_v4
# @param exports_file
#   String. It defines the location of file with the nfs export resources used
#   by the nfs server.
# @param idmapd_file
#   String. It defines the location of the file with the idmapd settings.
# @param defaults_file
#   String. It defines the location of the file with the nfs settings.
# @param manage_packages
#   Boolean. It defines if the packages should be managed through this module
# @param server_packages
#   Array. It defines the packages needed to be installed for acting as
#   a nfs server
# @param server_package_ensure
#   String. It defines the packages state - any of present, installed,
#   absent, purged, held, latest
# @param client_packages
#   Array. It defines the packages needed to be installed for acting as
#   a nfs client
# @param client_package_ensure
#   String. It defines the packages state - any of present, installed,
#   absent, purged, held, latest
# @param manage_server_service
#   Boolean. Defines if module should manage server_service
# @param manage_server_servicehelper
#   Boolean. Defines if module should manage server_servicehelper
# @param manage_client_service
#   Boolean. Defines if module should manage client_service
# @param server_service_name
#   String. It defines the servicename of the nfs server service
# @param server_service_ensure
#   Boolean. It defines the service parameter ensure for nfs server services.
# @param server_service_enable
#   Boolean. It defines the service parameter enable for nfs server service.
# @param server_service_hasrestart
#   Boolean. It defines the service parameter hasrestart for nfs server service.
# @param server_service_hasstatus
#   Boolean. It defines the service parameter hasstatus for nfs server service.
# @param server_service_restart_cmd
#   String. It defines the service parameter restart for nfs server service.
# @param server_nfsv4_servicehelper
#   Array. It defines the service helper like idmapd for servers configured with
#   nfs version 4.
# @param client_services
#   Nested Hash. It defines the servicenames need to be started when acting as a nfs client
# @param client_nfsv4_services
#   Nested Hash. It defines the servicenames need to be started when acting as a nfs client
#   version 4.
# @param client_services_enable
#   Boolean. It defines the service parameter enable for nfs client services.
# @param client_idmapd_setting
#   Array. It defines the Augeas parameter added in @param defaults_file when acting as a nfs
#   version 4 client.
# @param client_nfs_fstype
#   String. It defines the name of the nfs filesystem, when adding entries to /etc/fstab
#   on a client node.
# @param client_nfs_options
#   String. It defines the options for the nfs filesystem, when adding entries to /etc/fstab
#   on a client node.
# @param client_nfsv4_fstype
#   String. It defines the name of the nfs version 4 filesystem, when adding entries
#   to /etc/fstab on a client node.
# @param client_nfsv4_options
#   String. It defines the options for the nfs version 4filesystem, when adding entries
#   to /etc/fstab on a client node.
# @param nfs_v4_export_root
#   String. It defines the location where nfs version 4 exports should be bindmounted to
#   on a server node. Defaults to <tt>/export</tt>.
# @param nfs_v4_export_root_clients
#   String. It defines the clients that are allowed to mount nfs version 4 exports and
#   includes the option string. Defaults to
#   <tt>*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)</tt>.
# @param nfs_v4_mount_root
#   String. It defines the location where nfs version 4 clients find the mount root
#   on a server node. Defaults to <tt>/srv</tt>.
# @param nfs_v4_idmap_domain
#   String. It defines the name of the idmapd domain setting in @param idmapd_file needed
#   to be set to the same value on a server and client node to do correct uid and gid
#   mapping. Defaults to <tt>$::domain</tt>.
# @param nfsv4_bindmount_enable
#   Boolean. It defines if the module should create a bindmount for the export.
#   Defaults to <tt>true</tt>.
# @param client_need_gssd
#   Boolean. If true, sets NEED_GSSD=yes in /etc/defauls/nfs-common, usable on Debian/Ubuntu
# @param client_gssd_service
#   Boolean. If true enable rpc-gssd service.
# @param client_gssd_options
#   String. Options for rpc-gssd service. Defaults to <tt>''</tt>
# @param client_d9_gssdopt_workaround
#   Boolean. If enabled, workaround for passing gssd_options which is broken on Debian 9. Usable only on Debian 9
# @param nfs_v4_idmap_localrealms
#   String or Array. 'Local-Realms' option for idmapd. Defaults to <tt>''</tt>
# @param nfs_v4_idmap_cache
#   Integer. 'Cache-Expiration' option for idmapd. Defaults to <tt>0</tt> - unused.
# @param manage_nfs_v4_idmap_nobody_mapping
#   Boolean. Enable setting Nobody mapping in idmapd. Defaults to <tt>false</tt>.
# @param nfs_v4_idmap_nobody_user
#   String. 'Nobody-User' option for idmapd. Defaults to <tt>nobody</tt>.
# @param nfs_v4_idmap_nobody_group
#   String. 'Nobody-Group' option for idmapd. Defaults to <tt>nobody</tt> or <tt>nogroup</tt>.
# @param client_rpcbind_config
#   String. It defines the location of the file with the rpcbind config.
# @param client_rpcbind_optname
#   String. It defines the name of env variable that holds the rpcbind config. E.g. OPTIONS for Debian
# @param client_rpcbind_opts
#   String. Options for rpcbind service.
# @param nfs_v4_root_export_ensure
#   String. It defines the state of the nfs version 4 root export. Defaults to <tt>mounted</tt>.
# @param nfs_v4_root_export_mount
#   String. It defines the mountpoint of the nfs version 4 root export. Defaults to <tt>undef</tt>.
# @param nfs_v4_root_export_remounts
#   Boolean. It defines if the nfs version 4 root export should be remounted. Defaults to <tt>false</tt>.
# @param nfs_v4_root_export_atboot
#   Boolean. It defines if the nfs version 4 root export should be mounted at boot. Defaults to <tt>false</tt>.
# @param nfs_v4_root_export_options
#   String. It defines the options for the nfs version 4 root export. Defaults to <tt>_netdev</tt>.
# @param nfs_v4_root_export_bindmount
#   String. It defines the bindmount of the nfs version 4 root export. Defaults to <tt>undef</tt>.
# @param nfs_v4_root_export_tag
#   String. It defines the tag of the nfs version 4 root export. Defaults to <tt>undef</tt>.
# @param client_gssd_service_name
#   Hash. It defines the servicename of the rpc-gssd service.
# @param client_services_hasrestart
#   Boolean. It defines the service parameter hasrestart for nfs client services.
# @param client_services_hasstatus
#   Boolean. It defines the service parameter hasstatus for nfs client services.
# @param client_gssdopt_name
#   String. It defines the name of the gssd option in /etc/default/nfs-common.
# @example
# * {Please take a look at} [https://github.com/voxpupuli/puppet-nfs#examples]
#
# @author
# * Daniel Klockenkaemper <mailto:dk@marketing-factory.de>
# * Martin Alfke <tuxmea@gmail.com>
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
