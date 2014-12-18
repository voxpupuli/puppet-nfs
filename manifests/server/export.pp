# == Function: nfs::server::export
#
# This Function exists to
#  1. manage all exported resources on a nfs server
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

define nfs::server::export(
  $v3_export_name = $name,
  $v4_export_name = regsubst($name, '.*/(.*)', '\1' ),
  $clients        = 'localhost(ro)',
  $bind           = 'rbind',
  # globals for this share
  # propogated to storeconfigs
  $ensure         = 'mounted',
  $mount          = undef,
  $remounts       = false,
  $atboot         = false,
  $options        = '_netdev',
  $bindmount      = undef,
  $nfstag         = undef
) {

  if $nfs::server::nfs_v4 {
    nfs::functions::nfsv4_bindmount { $name:
      ensure         => $ensure,
      v4_export_name => $v4_export_name,
      bind           => $bind
    }
    nfs::functions::create_export { "${nfs::server::nfs_v4_export_root}/${v4_export_name}":
      ensure  => $ensure,
      clients => $clients,
      require => Nfs::Functions::Nfsv4_bindmount[$name]
    }

    @@nfs::client::mount {  $mount:
      ensure        => $ensure,
      remounts      => $remounts,
      atboot        => $atboot,
      options_nfsv4 => $options,
      bindmount     => $bindmount,
      nfstag        => $nfstag,
      share         => $v4_export_name,
      server        => $::clientcert,
    }
  } else {

    nfs::functions::create_export { $v3_export_name:
      ensure  => $ensure,
      clients => $clients,
    }

    @@nfs::client::mount { $mount:
      ensure      => $ensure,
      remounts    => $remounts,
      atboot      => $atboot,
      options_nfs => $options,
      nfstag      => $nfstag,
      share       => $v3_export_name,
      server      => $::clientcert,
    }
  }
}