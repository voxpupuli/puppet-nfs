# @summary Manage all mounts on a NFS client.
#
# @param server
#   Sets the ip address of the server with the NFS export.
#
# @param share
#   Sets the name of the NFS share on the server.
#
# @param ensure
#   Sets the ensure parameter of the mount.
#
# @param remounts
#   Sets the remounts parameter of the mount.
#
# @param atboot
#   Sets the atboot parameter of the mount.
#
# @param options_nfsv4
#   Sets the mount options for a NFS version 4 mount.
#
# @param options_nfs
#   Sets the mount options for a NFS mount.
#
# @param bindmount
#   When not undef it will create a bindmount on the node for the NFS mount.
#
# @param nfstag
#   Sets the nfstag parameter of the mount.
#
# param nfs_v4
#   When set to true, it uses NFS version 4 to mount a share.
#
# @param owner
#   Set owner of mount directory.
#
# @param group
#   Set group of mount directory.
#
# @param mode
#   Set mode of mount directory.
#
# @param mount_root
#   Overwrite mount root if differs from server configuration.
#
# @param mount
# @param manage_packages
# @param client_packages
# @param nfs_v4
#
# @example
#   class { '::nfs':
#     client_enabled => true,
#     nfs_v4_client  => true
#   }
#
#   nfs::client::mount { '/target/directory':
#     server        => '1.2.3.4',
#     share         => 'share_name_on_nfs_server',
#     remounts      => true,
#     atboot        => true,
#     options_nfsv4 => 'tcp,nolock,rsize=32768,wsize=32768,intr,noatime,actimeo=3'
#   }
#
# @author
#   * Daniel Klockenkaemper <dk@marketing-factory.de>
#   * Martin Alfke <tuxmea@gmail.com>
#
define nfs::client::mount (
  String[1]                                      $server,
  Optional[String[1]]                            $share           = undef,
  String[1]                                      $ensure          = 'mounted',
  String[1]                                      $mount           = $title,
  Boolean                                        $remounts        = false,
  Boolean                                        $atboot          = false,
  String[1]                                      $options_nfsv4   = $nfs::client_nfsv4_options,
  String[1]                                      $options_nfs     = $nfs::client_nfs_options,
  Optional[String[1]]                            $bindmount       = undef,
  Optional[String[1]]                            $nfstag          = undef,
  Boolean                                        $nfs_v4          = $nfs::client::nfs_v4,
  Optional[String[1]]                            $owner           = undef,
  Optional[String[1]]                            $group           = undef,
  Optional[String[1]]                            $mode            = undef,
  Optional[String[1]]                            $mount_root      = undef,
  Boolean                                        $manage_packages = $nfs::manage_packages,
  Optional[Variant[String[1], Array[String[1]]]] $client_packages = $nfs::effective_client_packages,
) {
  if $manage_packages and $client_packages != undef {
    $mount_require = [Nfs::Functions::Mkdir[$mount], Package[$client_packages]]
  } else {
    $mount_require = [Nfs::Functions::Mkdir[$mount]]
  }

  if $nfs_v4 == true {
    if $mount_root == undef {
      $root = ''
    } else {
      $root = $mount_root
    }

    if $share != undef {
      $sharename = "${root}/${share}"
    } else {
      $sharename = regsubst($mount, '.*(/.*)', '\1')
    }

    nfs::functions::mkdir { $mount:
      ensure => $ensure,
    }

    mount { "shared ${sharename} by ${server} on ${mount}":
      ensure   => $ensure,
      device   => "${server}:${sharename}",
      fstype   => $nfs::client_nfsv4_fstype,
      name     => $mount,
      options  => $options_nfsv4,
      remounts => $remounts,
      atboot   => $atboot,
      require  => $mount_require,
    }

    if $bindmount != undef {
      nfs::functions::bindmount { $mount:
        ensure     => $ensure,
        mount_name => $bindmount,
      }
    }
  } else {
    if $share != undef {
      $sharename = $share
    } else {
      $sharename = $mount
    }

    nfs::functions::mkdir { $mount:
      ensure => $ensure,
    }
    mount { "shared ${sharename} by ${server} on ${mount}":
      ensure   => $ensure,
      device   => "${server}:${sharename}",
      fstype   => $nfs::client_nfs_fstype,
      name     => $mount,
      options  => $options_nfs,
      remounts => $remounts,
      atboot   => $atboot,
      require  => $mount_require,
    }
  }

  if $owner != undef or $group != undef or $mode != undef {
    file { $mount:
      ensure  => $ensure == absent ? { true => 'absent', default => 'directory' },
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      force   => true,
      require => Mount["shared ${sharename} by ${server} on ${mount}"],
    }
  }
}
