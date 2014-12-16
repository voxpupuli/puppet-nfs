# == Class: nfs::init
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
  $nfs_v4              = $::nfs::params::nfs_v4,
  $nfs_v4_mount_root   = $::nfs::params::nfs_v4_mount_root,
  $nfs_v4_idmap_domain = $::nfs::params::nfs_v4_idmap_domain
) {

  anchor {'nfs::client::begin': }
  anchor {'nfs::client::end': }

  # package(s)
  class { 'nfs::client::package': }

  # configuration
  class { 'nfs::client::config': }

  # service(s)
  class { 'nfs::client::service': }

  define mkdir_p () {
    exec { "mkdir_recurse_${name}":
      path => [ '/bin', '/usr/bin' ],
      command => "mkdir -p ${name}",
      unless => "test -d ${name}"
    }
    file { $name:
      ensure  => directory,
      require => Exec["mkdir_recurse_${name}"]
    }
  }

  define bindmount (
    $mount_name = undef,
    $ensure = 'present'
  ) {
    mkdir_p { $mount_name: }
    mount { $mount_name:
      ensure  => $ensure,
      device  => $name,
      atboot  => true,
      fstype  => 'none',
      options => 'rw,bind',
      require => Mkdir_p[$mount_name]
    }
  }

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