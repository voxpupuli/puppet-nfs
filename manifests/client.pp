# Class: nfs::client
#
# @summary
# This class exists to
#  1. order the loading of classes
#  2. including all needed classes for nfs as a client
#
# @param ensure
#   The ensure parameter is used to determine if the nfs client should be configured
#   and running or not. Valid values are 'present' and 'absent'. Default is 'present'.
# @param nfs_v4
#   The nfs_v4 parameter is used to determine if the nfs client should use nfs version 4.
#   Valid values are 'true' and 'false'. Default is 'false'.
# @param nfs_v4_mount_root
#   The nfs_v4_mount_root parameter is used to determine the root directory for nfs version 4 mounts.
#   Default is '/mnt'.
# @param nfs_v4_idmap_domain
#   The nfs_v4_idmap_domain parameter is used to determine the domain for nfs version 4 id mapping.
#   Default is 'localdomain'.
# @author
# * Daniel Klockenkaemper <mailto:dk@marketing-factory.de>
# * Martin Alfke <tuxmea@gmail.com>
#
class nfs::client (
  String $ensure                     = $nfs::ensure,
  Boolean $nfs_v4                     = $nfs::nfs_v4_client,
  String $nfs_v4_mount_root          = $nfs::nfs_v4_mount_root,
  String $nfs_v4_idmap_domain        = $nfs::nfs_v4_idmap_domain,
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
