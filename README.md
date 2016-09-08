#nfs

####Table of Contents

1. [Overview - What is the nfs module?](#overview)
2. [Module Description - What does this module do?](#module-description)
3. [Setup - The basics of getting started with nfs](#setup)
4. [Usage - The class and available configurations](#usage)
5. [Requirements](#requirements)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Contributing to the nfs module](#contributing)

##Overview

Github Master: [![Build Status](https://secure.travis-ci.org/derdanne/puppet-nfs.png?branch=master)](https://travis-ci.org/derdanne/puppet-nfs)

This module installs, configures and manages everything on NFS clients and servers.

This module is a complete refactor of the module haraldsk/nfs, because Harald Skoglund sadly is not
maintaining his module actively anymore. It is stripped down to use only the class 'nfs'
and parametrized to act as a server, client or both with the parameters 'server_enabled'
and 'client_enabled'. It also has some dependencies on newer stdlib functions like 'difference'.

It supports the OS Families Ubuntu, Debian, Redhat, SUSE, Gentoo and Archlinux. It supports also Strict Variables, so if you pass all
OS specific parameters correctly it should work on your preferred OS too. Feedback, bugreports,
and feature requests are always welcome, visit https://github.com/derdanne/puppet-nfs or send me an email.

If you want to contribute, please do a fork on github, create a branch "feature name" with your
features and do a pull request.

##Module Description

This module can be used to simply mount nfs shares on a client or to configure your nfs servers.
It makes use of storeconfigs on the puppetmaster to get its resources. You can also easily use the
create_resources function when you store your exports i.e. via hiera.

##Setup

This Module depends on puppetlabs-stdlib >= 4.5.0 and puppetlabs-concat >= 1.1.2. It is tested till
Puppet Version 4.2.

Examples
----------------------

### Simple NFSv3 server and client example

This will export /data/folder on the server and automagically mount it on client.

```puppet
  node server {
    class { '::nfs':
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
    class { '::nfs':
      client_enabled => true,
    }
    Nfs::Client::Mount <<| |>>
  }
```

### Simple NFSv4 client example

This will mount /data on client in /share/data.

```pupppet
  class { '::nfs':
    server_enabled => false,
    client_enabled => true,
    nfs_v4_client => true,
    nfs_v4_idmap_domain => $::domain,
  }

  nfs::client::mount { '/share/data':
      server => '192.168.0.1',
      share => 'data',
  }
```


### NFSv3 multiple exports, servers and multiple node example

```puppet
  node server1 {
    class { '::nfs':
      server_enabled => true
    }
    nfs::server::export{
      '/data_folder':
        ensure  => 'mounted',
        clients => '10.0.0.0/24(rw,insecure,async,no_root_squash) localhost(rw)'
      # exports /homeexports and mounts them om /srv/home on the clients
      '/homeexport':
        ensure  => 'mounted',
        clients => '10.0.0.0/24(rw,insecure,async,root_squash)',
        mount   => '/srv/home'
  }

  node server2 {
    class { '::nfs':
      server_enabled => true
    }
    # ensure is passed to mount, which will make the client not mount it
    # the directory automatically, just add it to fstab
    nfs::server::export{
      '/media_library':
        ensure  => 'present',
        nfstag     => 'media'
        clients => '10.0.0.0/24(rw,insecure,async,no_root_squash) localhost(rw)'
  }

  node client {
    class { '::nfs':
      client_enabled => true,
    }
    Nfs::Client::Mount <<| |>>
  }

  # Using a storeconfig override, to change ensure option, so we mount
  # all shares
  node greedy_client {
    class { '::nfs':
      client_enabled => true,
    }
    Nfs::Client::Mount <<| |>> {
      ensure => 'mounted'
    }
  }


  # only the mount tagged as media
  # also override mount point
  node media_client {
    class { '::nfs':
      client_enabled => true,
    }
    Nfs::Client::Mount <<|nfstag == 'media' | >> {
      ensure => 'mounted',
      mount  => '/import/media'
    }
  }

  # All @@nfs::server::mount storeconfigs can be filtered by parameters
  # Also all parameters can be overridden (not that it's smart to do
  # so).
  # Check out the doc on exported resources for more info:
  # http://docs.puppetlabs.com/guides/exported_resources.html
  node single_server_client {
    class { '::nfs':
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
    class { '::nfs':
      server_enabled => true,
      nfs_v4         => true,
      nfs_v4_export_root_clients =>
        '10.0.0.0/24(rw,fsid=root,insecure,no_subtree_check,async,no_root_squash)'
    }
    nfs::server::export{ '/data_folder':
      ensure  => 'mounted',
      clients => '10.0.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash) localhost(rw)'
  }

  # By default, mounts are mounted in the same folder on the clients as
  # they were exported from on the server

  node client {
    class { '::nfs':
      client_enabled  => true,
      nfs_v4_client   => true,
      nfs_v4_export_root_clients =>
        '10.0.0.0/24(rw,fsid=root,insecure,no_subtree_check,async,no_root_squash)'
    }
    Nfs::Client::Mount <<| |>>
  }

  # We can also mount the NFSv4 Root directly through nfs::client::mount::nfsv4::root.
  # By default /srv will be used for as mount point, but can be overriden through
  # the 'mounted' option.

  node client2 {
    $server = 'server'
    class { '::nfs':
      client_enabled => true,
      nfs_v4_client  => true,
    }
    Nfs::Client::Mount::Nfs_v4::Root <<| server == $server |>> {
      mount => "/srv/$server",
    }
  }
```

### NFSv4 insanely overcomplicated reference example


```puppet
  # and on individual nodes.
  node server {
    class { '::nfs':
      server_enabled      => true,
      nfs_v4              => true,
      # Below are defaults
      nfs_v4_idmap_domain => $::domain,
      nfs_v4_export_root  => '/export',
      # Default access settings of /export root
      nfs_v4_export_root_clients =>
        "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)"


    }
    nfs::server::export{ '/data_folder':
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
      options   => '_netdev',
      # If set will mount share inside /srv (or overridden mount_root)
      # and then bindmount to another directory elsewhere in the fs -
      # for fanatics.
      bindmount => undef,
      # Used to identify a catalog item for filtering by by
      # storeconfigs, kick ass.
      nfstag     => undef,
      # copied directly into /etc/exports as a string, for simplicity
      clients => '10.0.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash)'
  }

  node client {
    class { '::nfs':
      client_enabled      => true,
      nfs_v4_client       => true,
      nfs_v4_idmap_domain => $::domain
      nfs_v4_mount_root   => '/srv',
    }

    # We can as you by now know, override options set on the server
    # on the client node.
    # Be careful. Don't override mount points unless you are sure
    # that only one export will match your filter!

    Nfs::Client::Mount <<| # filter goes here # |>> {
      # Directory where we want export mounted on client
      mount     => undef,
      remounts  => false,
      atboot    => false,
      #  Don't remove that option, but feel free to add more.
      options   => '_netdev',
      # If set will mount share inside /srv (or overridden mount_root)
      # and then bindmount to another directory elsewhere in the fs -
      # for fanatics.
      bindmount => undef,
    }
  }
```

### Simple create_resources with hiera example

#### HIERA:

```yaml
  nas::nfs_exports_global:
    /var/www: {}
    /var/smb: {}
```

#### PUPPET:

```puppet
  $nfs_exports_global = hiera_hash('nas::nfs_exports_global', false)

  class { '::nfs':
    server_enabled => true,
    client_enabled => false,
    nfs_v4 => true,
    nfs_v4_idmap_domain => $::domain,
    nfs_v4_export_root => '/share',
    nfs_v4_export_root_clients => '192.168.0.0/24(rw,fsid=root,insecure,no_subtree_check,async,no_root_squash)',
  }

  $defaults_nfs_exports = {
    ensure => 'mounted',
    clients => '192.168.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash)
  }

  if $nfs_exports_global {
    create_resources('::nfs::server::export', $nfs_exports_global, $defaults_nfs_exports)
  }
```

##Requirements

###Modules needed:

puppetlabs/stdlib >= 4.5.0
puppetlabs/concat >= 1.1.2

###Software versions needed:

facter > 1.6.2
puppet > 3.2.0

###Ruby Gems needed:

augeas

##Limitations
If you want to have specific package versions installed you may manage the needed packages outside of this 
module (use manage_packages => false). It is only tested to use 'present', 'installed', 'absent',
'purged', 'held' and 'latest' as argument for the parameters server_package_ensure and client_package_ensure.

##Contributing

Derdanne modules are open projects. So if you want to make this module even better,
you can contribute to this module on [Github](https://github.com/derdanne/puppet-nfs).

This module based on Harald Skoglund <haraldsk@redpill-linpro.com> from
https://github.com/haraldsk/puppet-module-nfs/ but has been fundementally refactored
