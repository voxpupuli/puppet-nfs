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
#   String. It defines the location of th file with the idmapd settings.
#
# [*defaults_file*]
#   String. It defines the location of th file with the nfs settings.
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
# [*$nfs_v4_root_export**]
#   Vary. These settings define the options of the exported resource of the export root.
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
  $ensure                       = 'present',
  $server_enabled               = false,
  $client_enabled               = false,
  $nfs_v4                       = $::nfs::params::nfs_v4,
  $nfs_v4_client                = $::nfs::params::nfs_v4,
  $exports_file                 = $::nfs::params::exports_file,
  $idmapd_file                  = $::nfs::params::idmapd_file,
  $defaults_file                = $::nfs::params::defaults_file,
  $manage_packages              = true,
  $server_packages              = $::nfs::params::server_packages,
  $server_package_ensure        = 'installed',
  $client_packages              = $::nfs::params::client_packages,
  $client_package_ensure        = 'installed',
  $manage_server_service        = true,
  $manage_server_servicehelper  = true,
  $manage_client_service        = true,
  $server_service_name          = $::nfs::params::server_service_name,
  $server_service_ensure        = 'running',
  $server_service_enable        = true,
  $server_service_hasrestart    = $::nfs::params::server_service_hasrestart,
  $server_service_hasstatus     = $::nfs::params::server_service_hasstatus,
  $server_service_restart_cmd   = $::nfs::params::server_service_restart_cmd,
  $server_nfsv4_servicehelper   = $::nfs::params::server_nfsv4_servicehelper,
  $client_services              = $::nfs::params::client_services,
  $client_nfsv4_services        = $::nfs::params::client_nfsv4_services,
  $client_services_hasrestart   = $::nfs::params::client_services_hasrestart,
  $client_services_hasstatus    = $::nfs::params::client_services_hasstatus,
  $client_idmapd_setting        = $::nfs::params::client_idmapd_setting,
  $client_nfs_fstype            = $::nfs::params::client_nfs_fstype,
  $client_nfs_options           = $::nfs::params::client_nfs_options,
  $client_nfsv4_fstype          = $::nfs::params::client_nfsv4_fstype,
  $client_nfsv4_options         = $::nfs::params::client_nfsv4_options,
  $nfs_v4_export_root           = $::nfs::params::nfs_v4_export_root,
  $nfs_v4_export_root_clients   = $::nfs::params::nfs_v4_export_root_clients,
  $nfs_v4_mount_root            = $::nfs::params::nfs_v4_mount_root,
  $nfs_v4_idmap_domain          = $::nfs::params::nfs_v4_idmap_domain,
  $nfs_v4_root_export_ensure    = 'mounted',
  $nfs_v4_root_export_mount     = undef,
  $nfs_v4_root_export_remounts  = false,
  $nfs_v4_root_export_atboot    = false,
  $nfs_v4_root_export_options   = '_netdev',
  $nfs_v4_root_export_bindmount = undef,
  $nfs_v4_root_export_tag       = undef,
) inherits nfs::params {

  # validate all params

  if ! ($ensure in [ 'present', 'absent', 'running', 'stopped', 'disabled' ]) {
    fail("\"${$ensure}\" is not a valid ensure parameter value")
  }

  validate_bool($server_enabled)
  validate_bool($client_enabled)
  validate_bool($nfs_v4)
  validate_bool($nfs_v4_client)
  validate_string($exports_file)
  validate_string($idmapd_file)
  validate_string($defaults_file)
  validate_bool($manage_packages)
  validate_array($server_packages)
  validate_string($server_package_ensure)
  validate_array($client_packages)
  validate_string($client_package_ensure)
  validate_bool($manage_server_service)
  validate_bool($manage_server_servicehelper)
  validate_bool($manage_client_service)
  validate_string($server_service_name)

  if ! ($server_service_ensure in [ 'present', 'absent', 'running', 'stopped', 'disabled' ]) {
    fail("\"${server_service_ensure}\" is not a valid ensure parameter value")
  }

  validate_bool($server_service_enable)
  validate_bool($server_service_hasrestart)
  validate_bool($server_service_hasstatus)
  validate_string($server_service_restart_cmd)
  validate_string($server_nfsv4_servicehelper)
  validate_hash($client_services)
  validate_hash($client_nfsv4_services)
  validate_bool($client_services_hasrestart)
  validate_bool($client_services_hasstatus)
  validate_array($client_idmapd_setting)
  validate_string($client_nfs_fstype)
  validate_string($client_nfs_options)
  validate_string($client_nfsv4_fstype)
  validate_string($client_nfsv4_options)
  validate_string($nfs_v4_export_root)
  validate_string($nfs_v4_export_root_clients)
  validate_string($nfs_v4_mount_root)
  validate_string($nfs_v4_idmap_domain)
  validate_string($nfs_v4_root_export_ensure)

  if $nfs_v4_root_export_mount != undef  {
    validate_string($nfs_v4_root_export_mount)
  }

  validate_bool($nfs_v4_root_export_remounts)
  validate_bool($nfs_v4_root_export_atboot)
  validate_string($nfs_v4_root_export_options)

  if $nfs_v4_root_export_bindmount != undef  {
    validate_string($nfs_v4_root_export_bindmount)
  }

  if $nfs_v4_root_export_tag != undef  {
    validate_string($nfs_v4_root_export_tag)
  }

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
