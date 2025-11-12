# puppet-nfs

[![Build Status](https://github.com/voxpupuli/puppet-nfs/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-nfs/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-nfs/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-nfs/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/nfs.svg)](https://forge.puppetlabs.com/puppet/nfs)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/nfs.svg)](https://forge.puppetlabs.com/puppet/nfs)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/nfs.svg)](https://forge.puppetlabs.com/puppet/nfs)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/nfs.svg)](https://forge.puppetlabs.com/puppet/nfs)
[![puppetmodule.info docs](https://www.puppetmodule.info/images/badge.svg)](https://www.puppetmodule.info/m/puppet-nfs)
[![Apache-2.0 License](https://img.shields.io/github/license/voxpupuli/puppet-nfs.svg)](LICENSE)
[![Donated by Daniel Klockenkaemper](https://img.shields.io/badge/donated%20by-Daniel%20Klockenkaemper-fb7047.svg)](#transfer-notice)

## Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with puppet-nfs](#setup)
    * [What puppet-nfs affects](#what-puppet-nfs-affects)
    * [Beginning with puppet-nfs](#beginning-with-puppet-nfs)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)

## Module Description

This module installs, configures and manages everything on NFS clients and servers.

This module is a complete refactor of the module haraldsk/nfs, because Harald Skoglund sadly is not
maintaining his module actively anymore. It is stripped down to use only the class 'nfs'
and parametrized to act as a server, client or both with the parameters 'server_enabled'
and 'client_enabled'.

It supports the OS Families Ubuntu, Debian, Redhat, SUSE, Gentoo and Archlinux. It supports also Strict Variables, so if you pass all
OS specific parameters correctly it should work on your preferred OS too. Feedback, bugreports,
and feature requests are always welcome, visit <https://github.com/voxpupuli/puppet-nfs>.

If you want to contribute, please do a fork on github, create a branch "feature name" with your
features and do a pull request.

## Setup

### What puppet-nfs affects

This module can be used to configure your nfs client and/or server, it could export
nfs mount resources via storeconfigs or simply mount nfs shares on a client. You can
also easily use the create_resources function when you store your exports i.e. via hiera.

### Beginning with puppet-nfs

On a nfs server the following code is sufficient to get all packages installed and services
running to use nfs:

```puppet
node server {
  class { 'nfs':
    server_enabled => true,
  }
}
```

On a client the following code is sufficient:

```puppet
node server {
  class { 'nfs':
    client_enabled => true,
  }
}
```

## Usage

### Simple NFSv3 server and client example

This will export /data_folder on the server and automagically mount it on client.

```puppet
node server {
  class { 'nfs':
    server_enabled => true
  }
  nfs::server::export{ '/data_folder':
    ensure  => 'mounted',
    clients => '10.0.0.0/24(rw,insecure,async,no_root_squash) localhost(rw)'
  }
}

# By default, mounts are mounted in the same folder on the clients as
# they were exported from on the server
node client {
  class { 'nfs':
    client_enabled => true,
  }
  Nfs::Client::Mount <<| |>>
}
```

### Simple NFSv4 client example

This will mount /data on client in /share/data.

```puppet
node client {
  class { 'nfs':
    server_enabled => false,
    client_enabled => true,
    nfs_v4_client => true,
    nfs_v4_idmap_domain => $::domain,
  }

  nfs::client::mount { '/share/data':
      server => '192.168.0.1',
      share => 'data',
  }
}
```

### NFSv3 multiple exports, servers and multiple node example

```puppet
node server1 {
  class { 'nfs':
    server_enabled => true,
  }
  nfs::server::export { '/data_folder':
    ensure  => 'mounted',
    clients => '10.0.0.0/24(rw,insecure,async,no_root_squash) localhost(rw)',
  }
  nfs::server::export { '/homeexport':
    ensure  => 'mounted',
    clients => '10.0.0.0/24(rw,insecure,async,root_squash)',
    mount   => '/srv/home',
  }
}

node server2 {
  class { 'nfs':
    server_enabled => true,
  }
  # ensure is passed to mount, which will make the client not mount it
  # the directory automatically, just add it to fstab
  # The directory on the NFS server is not created automatically.
  nfs::server::export { '/media_library':
    ensure     => 'present',
    nfstag     => 'media',
    clients    => '10.0.0.0/24(rw,insecure,async,no_root_squash) localhost(rw)',
    manage_dir => false,
  }
}

node client {
  class { 'nfs':
    client_enabled => true,
  }
  Nfs::Client::Mount <<| |>>
}

# Using a storeconfig override, to change ensure option, so we mount
# all shares
node greedy_client {
  class { 'nfs':
    client_enabled => true,
  }
  Nfs::Client::Mount <<| |>> {
    ensure => 'mounted',
  }
}


# only the mount tagged as media
# also override mount point
node media_client {
  class { 'nfs':
    client_enabled => true,
  }
  Nfs::Client::Mount <<| nfstag == 'media' |>> {
    ensure => 'mounted',
    mount  => '/import/media',
  }
}

# All @@nfs::server::mount storeconfigs can be filtered by parameters
# Also all parameters can be overridden (not that it's smart to do
# so).
# Check out the doc on exported resources for more info:
# http://docs.puppetlabs.com/guides/exported_resources.html
node single_server_client {
  class { 'nfs':
    client_enabled => true,
  }
  Nfs::Client::Mount <<| server == 'server1' |>> {
    ensure => 'absent',
  }
}
```

### NFSv4 Simple example

```puppet
# We use the $::domain fact for the Domain setting in
# /etc/idmapd.conf.
# For NFSv4 to work this has to be equal on servers and clients
# set it manually if unsure.
#
# All nfsv4 exports are bind mounted into /export/$mount_name
# and mounted on /srv/$mount_name on the client.
# Both values can be overridden through parameters both globally

# and on individual nodes.
node server {
  file { ['/data_folder', '/homeexport']:
    ensure => 'directory',
  }
  class { 'nfs':
    server_enabled => true,
    nfs_v4 => true,
    nfs_v4_idmap_domain => 'example.com',
    nfs_v4_export_root  => '/export',
    nfs_v4_export_root_clients => '*(rw,fsid=0,insecure,no_subtree_check,async,no_root_squash)',
  }
  nfs::server::export { '/data_folder':
    ensure  => 'mounted',
    clients => '*(rw,insecure,async,no_root_squash,no_subtree_check)',
  }
  nfs::server::export { '/homeexport':
    ensure  => 'mounted',
    clients => '*(rw,insecure,async,root_squash,no_subtree_check)',
    mount   => '/srv/home',
  }
}

# By default, mounts are mounted in the same folder on the clients as
# they were exported from on the server

node client {
  class { 'nfs':
    client_enabled  => true,
    nfs_v4_client   => true,
  }
  Nfs::Client::Mount <<| |>>
}

# We can also mount the NFSv4 Root directly through nfs::client::mount::nfsv4::root.
# By default /srv will be used for as mount point, but can be overriden through
# the 'mounted' option.

node client2 {
  $server = 'server'
  class { 'nfs':
    client_enabled => true,
    nfs_v4_client  => true,
  }
  Nfs::Client::Mount::Nfs_v4::Root <<| server == $server |>> {
    mount => "/srv/${server}",
  }
}
```

### NFSv4 insanely overcomplicated reference example

```puppet
# and on individual nodes.
node server {
  class { 'nfs':
    server_enabled      => true,
    nfs_v4              => true,
    # Below are defaults
    nfs_v4_idmap_domain => $::domain,
    nfs_v4_export_root  => '/export',
    # Default access settings of /export root
    nfs_v4_export_root_clients =>
      "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)",


  }
  nfs::server::export { '/data_folder':
    # These are the defaults
    ensure  => 'mounted',
    # rbind or bind mounting of folders bindmounted into /export
    # google it
    bind    => 'rbind',
    # everything below here is propogated by to storeconfigs
    # to clients
    #
    # Directory where we want export mounted on client
    mount     => undef,
    remounts  => false,
    atboot    => false,
    #  Don't remove that option, but feel free to add more.
    options_nfs   => '_netdev',
    # If set will mount share inside /srv (or overridden mount_root)
    # and then bindmount to another directory elsewhere in the fs -
    # for fanatics.
    bindmount => undef,
    # Used to identify a catalog item for filtering by by
    # storeconfigs, kick ass.
    nfstag     => 'kick-ass',
    # copied directly into /etc/exports as a string, for simplicity
    clients => '10.0.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash)',
  }
}

node client {
  class { 'nfs':
    client_enabled      => true,
    nfs_v4_client       => true,
    nfs_v4_idmap_domain => $::domain,
    nfs_v4_mount_root   => '/srv',
  }

  # We can as you by now know, override options set on the server
  # on the client node.
  # Be careful. Don't override mount points unless you are sure
  # that only one export will match your filter!

  Nfs::Client::Mount <<| nfstag == 'kick-ass' |>> {
    # Directory where we want export mounted on client
    mount       => undef,
    remounts    => false,
    atboot      => false,
    #  Don't remove that option, but feel free to add more.
    options_nfs => '_netdev',
    # If set will mount share inside /srv (or overridden mount_root)
    # and then bindmount to another directory elsewhere in the fs -
    # for fanatics.
    bindmount   => undef,
  }
}
```

### Simple create nfs export resources with hiera example

**Hiera Server Role:**

```yaml
classes:
  - nfs

nfs::server_enabled: true
nfs::client_enabled: false
nfs::nfs_v4: true
nfs::nfs_v4_idmap_domain: %{::domain}
nfs::nfs_v4_export_root: '/share'
nfs::nfs_v4_export_root_clients: '192.168.0.0/24(rw,fsid=root,insecure,no_subtree_check,async,no_root_squash)'

nfs::nfs_exports_global:
  /var/www: {}
  /var/smb: {}
```

**Hiera Client Role:**

```yaml
classes:
  - nfs

nfs::client_enabled: true
nfs::nfs_v4_client: true
nfs::nfs_v4_idmap_domain: %{::domain}
nfs::nfs_v4_mount_root: '/share'
nfs::nfs_server: 'nfs-server-fqdn'
```

**Puppet:**

```puppet
node server {
  hiera_include('classes')
  $nfs_exports_global = hiera_hash('nfs::nfs_exports_global', false)

  $defaults_nfs_exports = {
    ensure  => 'mounted',
    clients => '192.168.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash)',
    nfstag     => $::fqdn,
  }

  if $nfs_exports_global {
    create_resources('::nfs::server::export', $nfs_exports_global, $defaults_nfs_exports)
  }
}

node client {
  hiera_include('classes')
  $nfs_server = hiera('nfs::nfs_server', false)

  if $nfs_server {
    Nfs::Client::Mount <<| nfstag == $nfs_server |>>
  }
}
```

## Limitations

If you want to have specific package versions installed you may manage the needed packages outside of this
module (use manage_packages => false). It is only tested to use 'present', 'installed', 'absent',
'purged', 'held' and 'latest' as argument for the parameters server_package_ensure and client_package_ensure.

## Disclaimer

This module based on Harald Skoglund <haraldsk@redpill-linpro.com> from
https://github.com/haraldsk/puppet-module-nfs/ but has been fundementally refactored

## Transfer Notice

This plugin was originally authored by Daniel Klockenkaemper <dk@marketing-factory.de>.
The maintainer preferred that Vox Pupuli take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred over, please fork and continue to contribute here instead of Camptocamp.

Previously: https://github.com/derdanne/puppet-nfs
