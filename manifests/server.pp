# == Class: nfs::server
#
# This class exists to
#  1. order the loading of classes
#  2. including all needed classes for nfs as a server
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

class nfs::server (
  $ensure                       = $nfs::params::ensure,
  $nfs_v4                       = $nfs::params::nfs_v4,
  $nfs_v4_export_root           = $nfs::params::nfs_v4_export_root,
  $nfs_v4_export_root_clients   = $nfs::params::nfs_v4_export_root_clients,
  $nfs_v4_idmap_domain          = $nfs::params::nfs_v4_idmap_domain,
  $nfs_v4_root_export_ensure    = 'mounted',
  $nfs_v4_root_export_mount     = undef,
  $nfs_v4_root_export_remounts  = false,
  $nfs_v4_root_export_atboot    = false,
  $nfs_v4_root_export_options   = '_netdev',
  $nfs_v4_root_export_bindmount = undef,
  $nfs_v4_root_export_tag       = undef
){

  anchor {'nfs::server::begin': }
  anchor {'nfs::server::end': }

  # package(s)
  class { 'nfs::server::package': }

  # configuration
  class { 'nfs::server::config': }

  # service(s)
  class { 'nfs::server::service': }

  define createExport (
    $clients,
    $ensure = 'present'
  ) {
    if $ensure != 'absent' {
      $line = "${name} ${clients}\n"

      concat::fragment { $name:
        target  => '/etc/exports',
        content => $line
      }
    }
  }

  define nfsv4_bindmount (
    $v4_export_name,
    $bind,
    $ensure = 'mounted'
  ) {
    $expdir = "${nfs::server::nfs_v4_export_root}/${v4_export_name}"
    mkdir_p { $expdir: }
    mount { $expdir:
      ensure  => $ensure,
      device  => $name,
      atboot  => true,
      fstype  => 'none',
      options => $bind,
      require => Mkdir_p[$expdir],
    }
  }

  define mkdir_p () {
    exec { "mkdir_recurse_${name}":
      path    => ['/bin', '/usr/bin'],
      command => "mkdir -p ${name}",
      unless  => "test -d ${name}",
    }
    file { $name:
      ensure  => directory,
      require => Exec["mkdir_recurse_${name}"],
    }
  }

  if $ensure == 'present' {
    # we need the software before configuring it
    Anchor['nfs::server::begin']
    -> Class['nfs::server::package']
    -> Class['nfs::server::config']
    # we need the software and a working configuration before running a service
    Class['nfs::server::package'] -> Class['nfs::server::service']
    Class['nfs::server::config']  -> Class['nfs::server::service']
    Class['nfs::server::service'] -> Anchor['nfs::server::end']
  } else {
    # make sure all services are getting stopped before software removal
    Anchor['nfs::server::begin']
    -> Class['nfs::server::service']
    -> Class['nfs::server::package']
    -> Anchor['nfs::server::end']
  }
}