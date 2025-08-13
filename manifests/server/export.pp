# @summary Manage all exported resources on a NFS server.
#
# @param clients
#   Sets the allowed clients and options for the export in the exports file.
#
# @param bind
#   Sets the bind options setted in `/etc/fstab` for the bindmounts created.
#
# @param ensure
#   If enabled the mount will be created.
#
# @param remounts
#   Sets the remounts parameter of the mount.
#
# @param atboot
#   Sets the atboot parameter of the mount.
#
# @param options_nfsv4
#   Sets the mount options for a NFS version 4 exported resource mount.
#
# @param options_nfs
#   Sets the mount options for a NFS exported resource mount.
#
# @param bindmount
#   When not undef it will create a bindmount on the node for the NFS mount.
#
# @param nfstag
#   Sets the nfstag parameter of the mount.
#
# @param mount
#   Sets the mountpoint the client will mount the exported resource mount on. If undef it defaults to the same path as
#   on the server.
#
# @param owner
#   Sets the owner of the exported directory.
#
# @param group
#   Sets the group of the exported directory.
#
# @param mode
#   Sets the permissions of the exported directory.
#
# @param server
#   Sets the hostname clients will use to mount the exported resource. If undef it defaults to the trusted certname.
#
# @param v3_export_name
# @param v4_export_name
# @param nfsv4_bindmount_enable
#
# @param manage_directory
#   Whether or not to manage the directory to be exported.
#
# @example
#   class { '::nfs':
#     server_enabled             => true,
#     nfs_v4                     => true,
#     nfs_v4_export_root         => '/share',
#     nfs_v4_export_root_clients => '1.2.3.4/24(rw,fsid=root,insecure,no_subtree_check,async,no_root_squash)',
#   }
#
# nfs::server::export { '/srv/nfs_exported/directory':
#   clients => '1.2.3.4/24(rw,insecure,no_subtree_check,async,no_root_squash) 5.6.7.8/24(ro)',
#   share => 'share_name_on_nfs_server',
# }
#
# Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#   nfs::server::export { '/srv/nfs_exported/directory':
#     clients => '1.2.3.4/24(rw,insecure,no_subtree_check,async,no_root_squash) 5.6.7.8/24(ro)',
#     share => 'share_name_on_nfs_server',
#   }
#
# @author
#   * Daniel Klockenkaemper <dk@marketing-factory.de>
#   * Martin Alfke <mailto:tuxmea@gmail.com>
#
define nfs::server::export (
  String[1]           $v3_export_name         = $name,
  String[1]           $v4_export_name         = regsubst($name, '.*/(.*)', '\1' ),
  Variant[String[1],Array[String[1]]] $clients = 'localhost(ro)',
  String[1]           $bind                   = 'rbind',
  # globals for this share
  # propogated to storeconfigs
  String[1]           $ensure                 = 'mounted',
  Optional[String[1]] $mount                  = undef,
  Boolean             $remounts               = false,
  Boolean             $atboot                 = false,
  String[1]           $options_nfsv4          = $nfs::client_nfsv4_options,
  String[1]           $options_nfs            = $nfs::client_nfs_options,
  Optional[String[1]] $bindmount              = undef,
  Optional[String[1]] $nfstag                 = undef,
  Optional[String[1]] $owner                  = undef,
  Optional[String[1]] $group                  = undef,
  Optional[String[1]] $mode                   = undef,
  String[1]           $server                 = $facts['clientcert'],
  Boolean             $nfsv4_bindmount_enable = $nfs::nfsv4_bindmount_enable,
  Boolean             $manage_directory             = true,
) {
  if $nfs::server::nfs_v4 {
    if $nfsv4_bindmount_enable {
      $export_name = $v4_export_name
      $export_title = "${nfs::server::nfs_v4_export_root}/${export_name}"
      $create_export_require = [Nfs::Functions::Nfsv4_bindmount[$name]]

      nfs::functions::nfsv4_bindmount { $name:
        ensure         => $ensure,
        v4_export_name => $export_name,
        bind           => $bind,
      }
    } else {
      $export_name = $name
      $export_title = $name
      $create_export_require = []
    }

    nfs::functions::create_export { $export_title:
      ensure           => $ensure,
      clients          => $clients,
      manage_directory => $manage_directory,
      owner            => $owner,
      group            => $group,
      mode             => $mode,
      require          => $create_export_require,
    }

    if $mount != undef {
      $mount_name = $mount
    } else {
      $mount_name = $export_name
    }

    if $nfs::storeconfigs_enabled {
      @@nfs::client::mount { $mount_name:
        ensure        => $ensure,
        remounts      => $remounts,
        atboot        => $atboot,
        options_nfsv4 => $options_nfsv4,
        bindmount     => $bindmount,
        nfstag        => $nfstag,
        share         => $export_name,
        server        => $server,
      }
    }
  } else {
    if $mount != undef {
      $mount_name = $mount
    } else {
      $mount_name = $v3_export_name
    }

    nfs::functions::create_export { $v3_export_name:
      ensure           => $ensure,
      clients          => $clients,
      manage_directory => $manage_directory,
      owner            => $owner,
      group            => $group,
      mode             => $mode,
    }

    if $nfs::storeconfigs_enabled {
      @@nfs::client::mount { $mount_name:
        ensure      => $ensure,
        remounts    => $remounts,
        atboot      => $atboot,
        options_nfs => $options_nfs,
        nfstag      => $nfstag,
        share       => $v3_export_name,
        server      => $server,
      }
    }
  }
}
