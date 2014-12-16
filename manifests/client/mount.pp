# == Function: nfs::client::mount
#
# This Function exists to
#  1. manage all mounts on a nfs client
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

define nfs::client::mount (
  $mount            = $title,
  $server           = undef,
  $share            = undef,
  $ensure           = 'mounted',
  $remounts         = false,
  $atboot           = false,
  $options_nfsv4    = $::nfs::client_nfsv4_options,
  $options_nfs      = $::nfs::client_nfs_options,
  $bindmount        = undef,
  $nfstag           = undef,
  $nfs_v4           = $nfs::nfs_v4
){

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

  if $nfs::nfs_v4 == true {
    if $mount == undef {
      $mountname = "${nfs::client::nfs_v4_mount_root}/${share}"
    } else {
      $mountname = $mount
    }

    mkdir_p { $mountname: }
    mount { "shared ${share} by ${::clientcert} on ${mountname}":
      ensure   => $ensure,
      device   => "${server}:/${share}",
      fstype   => $nfs::client_nfsv4_fstype,
      name     => $mountname,
      options  => $options_nfsv4,
      remounts => $remounts,
      atboot   => $atboot,
      require  => Mkdir_p[$mountname]
    }

    if $bindmount != undef {
      bindmount { $mountname:
        ensure     => $ensure,
        mount_name => $bindmount
      }
    }
  } else {
    if $mount == undef {
      $mountname = $share
    } else {
      $mountname = $mount
    }

    mkdir_p { $mountname: }
    mount { "shared ${share} by ${::clientcert} on ${mountname}":
      ensure   => $ensure,
      device   => "${server}:${share}",
      fstype   => $nfs::client_nfs_fstype,
      name     => $mountname,
      options  => $options_nfs,
      remounts => $remounts,
      atboot   => $atboot,
      require  => Mkdir_p[$mountname]
    }
  }
}
