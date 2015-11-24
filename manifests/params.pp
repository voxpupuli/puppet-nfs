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
# * Daniel Klockenkaemper <mailto:dk@marketing-factory.de>
#

class nfs::params {
  #### Default values for the parameters of the main module class, init.pp

  $nfs_v4                     = false
  $nfs_v4_export_root         = '/export'
  $nfs_v4_export_root_clients = "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)"
  $nfs_v4_mount_root          = '/srv'
  $nfs_v4_idmap_domain        = $::domain

  # Different path definitions
  case $::osfamily {
    'Debian': {
      $exports_file   = '/etc/exports'
      $idmapd_file    = '/etc/idmapd.conf'
      $defaults_file  = '/etc/default/nfs-common'
    }
    'RedHat': {
      $exports_file   = '/etc/exports'
      $idmapd_file    = '/etc/idmapd.conf'
      $defaults_file  = '/etc/default/nfs-common'
    }
    'Gentoo': {
      $exports_file   = '/etc/exports'
      $idmapd_file    = '/etc/idmapd.conf'
      $defaults_file  = '/etc/conf.d/nfs'
    }
    'Suse': {
      $exports_file   = '/etc/exports'
      $idmapd_file    = '/etc/idmapd.conf'
      $defaults_file  = undef
    }
    default: {
      $exports_file   = undef
      $idmapd_file    = undef
      $defaults_file  = undef
      notice("\"${module_name}\" provides no config directory default values for OS family \"${::osfamily}\"")
    }
  }


  # packages - ensure
  case $::osfamily {
    'Debian': {
      $server_packages = [ 'nfs-common', 'nfs-kernel-server', 'nfs4-acl-tools', 'rpcbind' ]
      $client_packages = [ 'nfs-common', 'nfs4-acl-tools' ]
    }
    'RedHat': {
      $server_packages = [ 'nfs-utils', 'nfs4-acl-tools', 'rpcbind' ]
      $client_packages = [ 'nfs-utils', 'nfs4-acl-tools', 'rpcbind' ]
    }
    'Gentoo': {
      $server_packages = ['net-nds/rpcbind', 'net-fs/nfs-utils', 'net-libs/libnfsidmap']
      $client_packages = ['net-nds/rpcbind', 'net-fs/nfs-utils', 'net-libs/libnfsidmap']
    }
    'Suse': {
      $server_packages = ['nfs-kernel-server']
      $client_packages = ['nfsidmap', 'nfs-client', 'rpcbind']
    }
    default: {
      $server_packages = undef
      $client_packages = undef
      notice("\"${module_name}\" provides no package default values for OS family \"${::osfamily}\"")
    }
  }

  # service parameters
  # params that are the same on all (known) OSes.
  $client_nfs_fstype          = 'nfs'
  $client_services_hasrestart = true
  $client_services_hasstatus  = true
  $server_service_hasrestart  = true
  $server_service_hasstatus   = true
  # params with OS-specific values
  case "${::osfamily}-${::operatingsystemmajrelease}" {
    /^Debian/: {
      $client_idmapd_setting      = [ 'set NEED_IDMAPD yes' ]
      $client_nfs_options         = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,nfsvers=3,actimeo=3'
      $client_services            = { 'rpcbind' => {} }
      $client_nfsv4_fstype        = 'nfs4'
      $client_nfsv4_options       = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,actimeo=3'
      $client_nfsv4_services      = { 'rpcbind' => {}, 'idmapd' => {} }
      $server_nfsv4_servicehelper = 'idmapd'
      $server_service_name        = 'nfs-kernel-server'
    }
    'RedHat-7': {
      $client_idmapd_setting      = [ '' ]
      $client_nfs_options         = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,actimeo=3'
      $client_services            = { 'rpcbind.service' => {} }
      $client_nfsv4_fstype        = 'nfs4'
      $client_nfsv4_options       = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,actimeo=3'
      $client_nfsv4_services      = { 'rpcbind.service' => {}, 'nfs-idmap.service' => {} }
      $server_nfsv4_servicehelper = 'nfs-idmap.service'
      $server_service_name        = 'nfs-server.service'
    }
    /^RedHat/: {
      $client_idmapd_setting      = [ '' ]
      $client_nfs_options         = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,actimeo=3'
      $client_services            = { 'rpcbind' => {} }
      $client_nfsv4_fstype        = 'nfs4'
      $client_nfsv4_options       = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,actimeo=3'
      $client_nfsv4_services      = { 'rpcbind' => {}, 'rpcidmapd' => {} }
      $server_nfsv4_servicehelper = 'rpcidmapd'
      $server_service_name        = 'nfs'
    }
    /^Gentoo/: {
      $client_idmapd_setting      = [ 'set NFS_NEEDED_SERVICES rpc.idmapd' ]
      $client_nfs_options         = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,nfsvers=3,actimeo=3'
      $client_services            = { 'rpcbind' => {} }
      $client_nfsv4_fstype        = 'nfs'
      $client_nfsv4_options       = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,nfsvers=4,actimeo=3'
      $client_nfsv4_services      = { 'rpcbind' => {}, 'rpc.idmapd' => {} }
      $server_nfsv4_servicehelper = 'rpc.idmapd'
      $server_service_name        = 'nfs'
    }
    /^Suse/: {
      $client_idmapd_setting      = [ '' ]
      $client_nfs_options         = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,nfsvers=3,actimeo=3'
      $client_services            = { 'rpcbind' => { before => Service['nfs'] }, 'nfs' => {} }
      $client_nfsv4_fstype        = 'nfs4'
      $client_nfsv4_options       = 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,nfsvers=4,actimeo=3'
      $client_nfsv4_services      = { 'rpcbind' => { before => Service['nfs'] }, 'nfs' => {} }
      $server_service_name        = 'nfsserver'
    }
    default: {
      # need to explicitly set unknown params to undef to work with strict_variables=true
      $client_idmapd_setting      = undef
      $client_nfs_options         = undef
      $client_nfsv4_fstype        = undef
      $client_nfsv4_options       = undef
      $client_nfsv4_services      = undef
      $server_nfsv4_servicehelper = undef
      $server_service_name        = undef
      notice("\"${module_name}\" provides no service parameters for OS family \"${::osfamily}\"")
    }
  }
}
