# @summary Manage the NFS client
#
# This class exists to:
# 1. Order the loading of classes,
# 2. Including all needed classes for NFS as a client.
#
# @param ensure
#   The ensure parameter is used to determine if the NFS client should be configured and running or not.
#
# @param nfs_v4
#   The nfs_v4 parameter is used to determine if the NFS client should use NFS version 4.
#
# @param nfs_v4_mount_root
#   The nfs_v4_mount_root parameter is used to determine the root directory for NFS version 4 mounts.
#
# @param nfs_v4_idmap_domain
#   The nfs_v4_idmap_domain parameter is used to determine the domain for NFS version 4 id mapping.
#
# @author
#   * Daniel Klockenkaemper <dk@marketing-factory.de>
#   * Martin Alfke <tuxmea@gmail.com>
#
class nfs::client (
  String  $ensure              = $nfs::ensure,
  Boolean $nfs_v4              = $nfs::nfs_v4_client,
  String  $nfs_v4_mount_root   = $nfs::nfs_v4_mount_root,
  String  $nfs_v4_idmap_domain = $nfs::nfs_v4_idmap_domain,
) {
  # package(s)
  class { 'nfs::client::package': }

  # configuration
  class { 'nfs::client::config': }

  # service(s)
  class { 'nfs::client::service': }

  if $ensure == 'present' {
    # we need the software before configuring it
    Class['nfs::client::package']
    -> Class['nfs::client::config']
    -> Class['nfs::client::service']
  } else {
    # make sure all services are getting stopped before software removal
    Class['nfs::client::service']
    -> Class['nfs::client::package']
  }
}
