# == Class: nfs::server::config
#
# This class exists to
#  1. configure nfs as a server
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

class nfs::server::config {

  concat { '/etc/exports':
    ensure  => present,
  }

  concat::fragment { 'nfs_exports_header':
    target  => '/etc/exports',
    content => "# This file is configured through the nfs::server puppet module\n",
    order   => 01;
  }

  if $::nfs::nfs_v4 == true {
    concat::fragment { 'nfs_exports_root':
      target  => '/etc/exports',
      content => "${nfs::server::nfs_v4_export_root} ${nfs::server::nfs_v4_export_root_clients}\n",
      order   => 02
    }
    file { $nfs::server::nfs_v4_export_root:
      ensure => directory,
    }

    @@nfs::client::mount::nfs_v4::root {"shared server root by ${::clientcert}":
      ensure    => $nfs::server::nfs_v4_root_export_ensure,
      mount     => $nfs::server::nfs_v4_root_export_mount,
      remounts  => $nfs::server::nfs_v4_root_export_remounts,
      atboot    => $nfs::server::nfs_v4_root_export_atboot,
      options   => $nfs::server::nfs_v4_root_export_options,
      bindmount => $nfs::server::nfs_v4_root_export_bindmount,
      nfstag    => $nfs::server::nfs_v4_root_export_tag,
      server    => $::clientcert,
    }
  }
}