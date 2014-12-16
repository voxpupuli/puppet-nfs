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

  if $nfs::nfs_v4 == true {
    if $mount == undef {
      $mountname = "${nfs::client::nfs_v4_mount_root}/${share}"
    } else {
      $mountname = $mount
    }

    nfs::client::mkdir_p { $mountname: }
    mount { "shared ${share} by ${::clientcert} on ${mountname}":
      ensure   => $ensure,
      device   => "${server}:/${share}",
      fstype   => $nfs::client_nfsv4_fstype,
      name     => $mountname,
      options  => $options_nfsv4,
      remounts => $remounts,
      atboot   => $atboot,
      require  => Nfs::Client::Mkdir_p[$mountname]
    }

    if $bindmount != undef {
      nfs::client::bindmount { $mountname:
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

    nfs::client::mkdir_p { $mountname: }
    mount { "shared ${share} by ${::clientcert} on ${mountname}":
      ensure   => $ensure,
      device   => "${server}:${share}",
      fstype   => $nfs::client_nfs_fstype,
      name     => $mountname,
      options  => $options_nfs,
      remounts => $remounts,
      atboot   => $atboot,
      require  => Nfs::Client::Mkdir_p[$mountname]
    }
  }
}
