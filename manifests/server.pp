# @summary Manage the NFS server.
#
# This class exists to:
# 1. Order the loading of classes,
# 2. Including all needed classes for NFS as a server.
#
# @param ensure
# @param nfs_v4
# @param nfs_v4_export_root
# @param nfs_v4_export_root_clients
# @param nfs_v4_idmap_domain
# @param nfs_v4_root_export_ensure
# @param nfs_v4_root_export_mount
# @param nfs_v4_root_export_remounts
# @param nfs_v4_root_export_atboot
# @param nfs_v4_root_export_options
# @param nfs_v4_root_export_bindmount
# @param nfs_v4_root_export_tag
#
# @author
#   * Daniel Klockenkaemper <dk@marketing-factory.de>
#   * Martin Alfke <mailto:tuxmea@gmail.com>
#
class nfs::server (
  Enum['present', 'absent', 'running', 'stopped', 'disabled'] $ensure                       = $nfs::ensure,
  Boolean                                                     $nfs_v4                       = $nfs::nfs_v4,
  String                                                      $nfs_v4_export_root           = $nfs::nfs_v4_export_root,
  String                                                      $nfs_v4_export_root_clients   = $nfs::nfs_v4_export_root_clients,
  String                                                      $nfs_v4_idmap_domain          = $nfs::nfs_v4_idmap_domain,
  String                                                      $nfs_v4_root_export_ensure    = $nfs::nfs_v4_root_export_ensure,
  Optional[String]                                            $nfs_v4_root_export_mount     = $nfs::nfs_v4_root_export_mount,
  Boolean                                                     $nfs_v4_root_export_remounts  = $nfs::nfs_v4_root_export_remounts,
  Boolean                                                     $nfs_v4_root_export_atboot    = $nfs::nfs_v4_root_export_atboot ,
  String                                                      $nfs_v4_root_export_options   = $nfs::nfs_v4_root_export_options,
  Optional[String]                                            $nfs_v4_root_export_bindmount = $nfs::nfs_v4_root_export_bindmount,
  Optional[String]                                            $nfs_v4_root_export_tag       = $nfs::nfs_v4_root_export_tag,
) {
  # package(s)
  class { 'nfs::server::package': }

  # configuration
  class { 'nfs::server::config': }

  # service(s)
  class { 'nfs::server::service': }

  if $ensure == 'present' {
    # we need the software before configuring it
    Class['nfs::server::package']
    -> Class['nfs::server::config']
    -> Class['nfs::server::service']
  } else {
    # make sure all services are getting stopped before software removal
    Class['nfs::server::service']
    -> Class['nfs::server::package']
  }
}
