# == Class: nfs::client
#
# This class exists to
#  1. order the loading of classes
#  2. including all needed classes for nfs as a client
#
# === Parameters
#
# TODO: has to be filled
#
# === Examples
#
# TODO: has to be filled
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * Daniel Klockenkämper <mailto:dk@marketing-factory.de>
#

class nfs::client (
  $ensure                     = $::nfs::ensure,
  $nfs_v4                     = $::nfs::nfs_v4,
  $nfs_v4_mount_root          = $::nfs::nfs_v4_mount_root,
  $nfs_v4_idmap_domain        = $::nfs::nfs_v4_idmap_domain,
  $server_packages            = $::nfs::server_packages,
  $server_nfsv4_servicehelper = $::nfs::server_nfsv4_servicehelper,
  $client_packages            = $::nfs::client_packages,
  $client_services            = $::nfs::client_services,
  $client_nfsv4_services      = $::nfs::client_nfsv4_services
) {

  anchor {'nfs::client::begin': }
  anchor {'nfs::client::end': }

  # package(s)
  class { 'nfs::client::package': }

  # configuration
  class { 'nfs::client::config': }

  # service(s)
  class { 'nfs::client::service': }

  if $ensure == 'present' {
    # we need the software before configuring it
    Anchor['nfs::client::begin']
    -> Class['nfs::client::package']
    -> Class['nfs::client::config']
    # we need the software and a working configuration before running a service
    Class['nfs::client::package'] -> Class['nfs::client::service']
    Class['nfs::client::config']  -> Class['nfs::client::service']
    Class['nfs::client::service'] -> Anchor['nfs::client::end']
  } else {
    # make sure all services are getting stopped before software removal
    Anchor['nfs::client::begin']
    -> Class['nfs::client::service']
    -> Class['nfs::client::package']
    -> Anchor['nfs::client::end']
  }
}