# == Class: nfs::init
#
# This class exists to
# === Parameters
#
# [*ensure*]
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
#
# [*server_enabled*]
#   Boolean. If set to <tt>true</tt>, this module will configure the node
#   to act as a nfs server.
#
# [*client_enabled*]
#   Boolean. If set to <tt>true</tt>, this module will configure the node
#   to act as a client server, you can use the exported mount resources
#   from configured servers.
#
# [*storeconfigs_enabled*]
#   Boolean. If set to <tt>false</tt>, this module will not export any
#   resources as storeconfigs. Defaults to <tt>true</tt>.
#
# [*nfs_v4*]
#   Boolean. If set to <tt>true</tt>, this module will use nfs version 4
#   for exporting and mounting nfs resources.
#
# [*nfs_v4_client*]
#   Boolean. If set to <tt>true</tt>, this module will use nfs version 4
#   for mounting nfs resources. If set to <tt>false</tt> it will use nfs
#   version 3 to mount nfs resources. It defaults to the setting of [*nfs_v4*]
#
# [*exports_file*]
#   String. It defines the location of file with the nfs export resources used
#   by the nfs server.
#
# [*idmapd_file*]
#   String. It defines the location of the file with the idmapd settings.
#
# [*defaults_file*]
#   String. It defines the location of the file with the nfs settings.
#
# [*manage_packages*]
#   Boolean. It defines if the packages should be managed through this module
#
# [*server_packages*]
#   Array. It defines the packages needed to be installed for acting as
#   a nfs server
#
# [*server_package_ensure*]
#   String. It defines the packages state - any of present, installed,
#   absent, purged, held, latest
#
# [*client_packages*]
#   Array. It defines the packages needed to be installed for acting as
#   a nfs client
#
# [*client_package_ensure*]
#   String. It defines the packages state - any of present, installed,
#   absent, purged, held, latest
#
# [*manage_server_service*]
#   Boolean. Defines if module should manage server_service
#
# [*manage_server_servicehelper*]
#   Boolean. Defines if module should manage server_servicehelper
#
# [*manage_client_service*]
#   Boolean. Defines if module should manage client_service
#
# [*server_service_name*]
#   String. It defines the servicename of the nfs server service
#
# [*server_service_ensure*]
#   Boolean. It defines the service parameter ensure for nfs server services.
#
# [*server_service_enable*]
#   Boolean. It defines the service parameter enable for nfs server service.
#
# [*server_service_hasrestart*]
#   Boolean. It defines the service parameter hasrestart for nfs server service.
#
# [*server_service_hasstatus*]
#   Boolean. It defines the service parameter hasstatus for nfs server service.
#
# [*server_service_restart_cmd*]
#   String. It defines the service parameter restart for nfs server service.
#
# [*server_nfsv4_servicehelper*]
#   String. It defines the service helper like idmapd for servers configured with
#   nfs version 4.
#
# [*client_services*]
#   Nested Hash. It defines the servicenames need to be started when acting as a nfs client
#
# [*client_nfsv4_services*]
#   Nested Hash. It defines the servicenames need to be started when acting as a nfs client
#   version 4.
#
# [*client_services_enable*]
#   Boolean. It defines the service parameter enable for nfs client services.
#
# [*client_service_hasrestart*]
#   Boolean. It defines the service parameter hasrestart for nfs client services.
#
# [*client_service_hasstatus*]
#   Boolean. It defines the service parameter hasstatus for nfs client services.
#
# [*client_idmapd_setting*]
#   Array. It defines the Augeas parameter added in [*defaults_file*] when acting as a nfs
#   version 4 client.
#
# [*client_nfs_fstype*]
#   String. It defines the name of the nfs filesystem, when adding entries to /etc/fstab
#   on a client node.
#
# [*client_nfs_options*]
#   String. It defines the options for the nfs filesystem, when adding entries to /etc/fstab
#   on a client node.
#
# [*client_nfsv4_fstype*]
#   String. It defines the name of the nfs version 4 filesystem, when adding entries
#   to /etc/fstab on a client node.
#
# [*client_nfsv4_options*]
#   String. It defines the options for the nfs version 4filesystem, when adding entries
#   to /etc/fstab on a client node.
#
# [*nfs_v4_export_root*]
#   String. It defines the location where nfs version 4 exports should be bindmounted to
#   on a server node. Defaults to <tt>/export</tt>.
#
# [*nfs_v4_export_root_clients*]
#   String. It defines the clients that are allowed to mount nfs version 4 exports and
#   includes the option string. Defaults to
#   <tt>*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)</tt>.
#
# [*nfs_v4_mount_root*]
#   String. It defines the location where nfs version 4 clients find the mount root
#   on a server node. Defaults to <tt>/srv</tt>.
#
# [*nfs_v4_idmap_domain*]
#   String. It defines the name of the idmapd domain setting in [*idmapd_file*] needed
#   to be set to the same value on a server and client node to do correct uid and gid
#   mapping. Defaults to <tt>$::domain</tt>.
#
# === Examples
#
# * {Please take a look at} [https://github.com/derdanne/puppet-nfs#examples]
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

class nfs(
  Enum['present', 'absent', 'running', 'stopped', 'disabled'] $ensure                 = 'present',
  Boolean $server_enabled                                                             = false,
  Boolean $client_enabled                                                             = false,
  Boolean $storeconfigs_enabled                                                       = true,
  Boolean $nfs_v4                                                                     = $::nfs::params::nfs_v4,
  Boolean $nfs_v4_client                                                              = $::nfs::params::nfs_v4,
  Stdlib::Absolutepath $exports_file                                                  = $::nfs::params::exports_file,
  Stdlib::Absolutepath $idmapd_file                                                   = $::nfs::params::idmapd_file,
  Optional[Stdlib::Absolutepath] $defaults_file                                       = $::nfs::params::defaults_file,
  Boolean $manage_packages                                                            = true,
  Array $server_packages                                                              = $::nfs::params::server_packages,
  String $server_package_ensure                                                       = 'installed',
  Array $client_packages                                                              = $::nfs::params::client_packages,
  String $client_package_ensure                                                       = 'installed',
  Boolean $manage_server_service                                                      = true,
  Boolean $manage_server_servicehelper                                                = true,
  Boolean $manage_client_service                                                      = true,
  String $server_service_name                                                         = $::nfs::params::server_service_name,
  Enum['present', 'absent', 'running', 'stopped', 'disabled'] $server_service_ensure  = 'running',
  Boolean $server_service_enable                                                      = true,
  Boolean $server_service_hasrestart                                                  = $::nfs::params::server_service_hasrestart,
  Boolean $server_service_hasstatus                                                   = $::nfs::params::server_service_hasstatus,
  Optional[String] $server_service_restart_cmd                                        = $::nfs::params::server_service_restart_cmd,
  Optional[String] $server_nfsv4_servicehelper                                        = $::nfs::params::server_nfsv4_servicehelper,
  $client_services                                                                    = $::nfs::params::client_services,
  $client_nfsv4_services                                                              = $::nfs::params::client_nfsv4_services,
  Boolean $client_services_enable                                                     = $::nfs::params::client_services_enable,
  Boolean $client_services_hasrestart                                                 = $::nfs::params::client_services_hasrestart,
  Boolean $client_services_hasstatus                                                  = $::nfs::params::client_services_hasstatus,
  Array[String] $client_idmapd_setting                                                = $::nfs::params::client_idmapd_setting,
  String $client_nfs_fstype                                                           = $::nfs::params::client_nfs_fstype,
  String $client_nfs_options                                                          = $::nfs::params::client_nfs_options,
  String $client_nfsv4_fstype                                                         = $::nfs::params::client_nfsv4_fstype,
  String $client_nfsv4_options                                                        = $::nfs::params::client_nfsv4_options,
  String $nfs_v4_export_root                                                          = $::nfs::params::nfs_v4_export_root,
  String $nfs_v4_export_root_clients                                                  = $::nfs::params::nfs_v4_export_root_clients,
  String $nfs_v4_mount_root                                                           = $::nfs::params::nfs_v4_mount_root,
  String $nfs_v4_idmap_domain                                                         = $::nfs::params::nfs_v4_idmap_domain,
  String $nfs_v4_root_export_ensure                                                   = 'mounted',
  Optional[String] $nfs_v4_root_export_mount                                          = undef,
  Boolean $nfs_v4_root_export_remounts                                                = false,
  Boolean $nfs_v4_root_export_atboot                                                  = false,
  String $nfs_v4_root_export_options                                                  = '_netdev',
  Optional[String] $nfs_v4_root_export_bindmount                                      = undef,
  Optional[String] $nfs_v4_root_export_tag                                            = undef,
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

    $effective_nfsv4_client_services = $client_nfsv4_services
    $effective_client_services = $client_services
    $effective_client_packages = $client_packages

  }

  if $server_enabled {
    class { '::nfs::server': }
  }

  if $client_enabled {
    class { '::nfs::client': }
  }
}
