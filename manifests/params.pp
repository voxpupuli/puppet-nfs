# == Class: nfs::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
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

class nfs::params {
  #### Default values for the parameters of the main module class, init.pp

  $nfs_v4_export_root         = '/export'
  $nfs_v4_export_root_clients = "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)"
  $nfs_v4_mount_root          = '/srv'
  $nfs_v4_idmap_domain        = $::domain

  # Different path definitions
  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      $exports_file   = '/etc/exports'
      $idmapd_file    = '/etc/idmapd.conf'
      $defaults_file  = '/etc/default/nfs-common'
    }
    'Redhat': {
      $exports_file   = '/etc/exports'
      $idmapd_file    = '/etc/idmapd.conf'
      $defaults_file  = '/etc/default/nfs-common'
    }
    'Gentoo': {
      $exports_file   = '/etc/exports'
      $idmapd_file    = '/etc/idmapd.conf'
      $defaults_file  = '/etc/conf.d/nfs'
    }
    default: {
      fail("\"${module_name}\" provides no config directory default value
           for \"${::kernel}\"")
    }
  }


  # packages - ensure
  case $::operatingsystem {
  'Debian', 'Ubuntu': {
      $server_packages = [ 'nfs-common', 'nfs-kernel-server', 'nfs4-acl-tools', 'rpcbind' ]
      $client_packages = [ 'nfs-common', 'nfs4-acl-tools' ]
    }
    'Redhat': {
      $server_packages = [ 'nfs-utils', 'nfs4-acl-tools', 'rpcbind' ]
      $client_packages = [ 'nfs-utils', 'nfs4-acl-tools', 'rpcbind' ]
    }
    'Gentoo': {
      $server_packages = ['net-nds/rpcbind', 'net-fs/nfs-utils', 'net-libs/libnfsidmap']
      $client_packages = ['net-nds/rpcbind', 'net-fs/nfs-utils', 'net-libs/libnfsidmap']
    }
    default: {
      fail("\"${module_name}\" provides no package default value
            for \"${::operatingsystem}\"")
    }
  }

  # service parameters
  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      $server_service_name        = 'nfs-kernel-server'
      $server_service_hasrestart  = true
      $server_service_hasstatus   = true
      $server_nfsv4_servicehelper = 'idmapd'
      $client_services            = { 'rpcbind' => {} }
      $client_nfsv4_services      = { 'rpcbind' => {}, 'nfs-lock' => {}, 'idmapd' => {} }
      $client_services_hasrestart = true
      $client_services_hasstatus  = true
      $client_idmapd_setting      = [ 'set NEED_IDMAPD yes' ]
      $client_nfs_fstype          = 'nfs'
      $client_nfs_options         = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,actimeo=3'
      $client_nfsv4_fstype        = 'nfs4'
      $client_nfsv4_options       = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,actimeo=3'
    }
    'Redhat': {
      $server_service_name        = 'nfs'
      $server_service_hasrestart  = true
      $server_service_hasstatus   = true
      $server_nfsv4_servicehelper = 'idmapd'
      $client_services            = { 'rpcbind' => {} }
      $client_nfsv4_services      = { 'rpcbind' => {}, 'idmapd' => {} }
      $client_services_hasrestart = true
      $client_services_hasstatus  = true
      $client_idmapd_setting      = undef
      $client_nfs_fstype          = 'nfs'
      $client_nfs_options         = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,actimeo=3'
      $client_nfsv4_fstype        = 'nfs4'
      $client_nfsv4_options       = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,actimeo=3'
    }
    'Gentoo': {
      $server_service_name        = 'nfs'
      $server_service_hasrestart  = true
      $server_service_hasstatus   = true
      $server_nfsv4_servicehelper = 'rpc.idmapd'
      $client_services            = { 'rpcbind' => {} }
      $client_nfsv4_services      = { 'rpcbind' => {}, 'rpc.idmapd' => {} }
      $client_services_hasrestart = true
      $client_services_hasstatus  = true
      $client_idmapd_setting      = [ 'set NFS_NEEDED_SERVICES rpc.idmapd' ]
      $client_nfs_fstype          = 'nfs'
      $client_nfs_options         = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,nfsvers=3,actimeo=3'
      $client_nfsv4_fstype        = 'nfs'
      $client_nfsv4_options       = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,nfsvers=4,actimeo=3'
    }
    default: {
      fail("\"${module_name}\" provides no service parameters
            for \"${::operatingsystem}\"")
    }
  }
}