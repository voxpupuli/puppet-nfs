# nfs

#### Table of Contents
1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with derdanne-nfs](#setup)
    * [What derdanne-nfs affects](#what-derdanne-nfs-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with derdanne-nfs](#beginning-with-derdanne-nfs)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Module Description

Github Master: [![Build Status](https://secure.travis-ci.org/derdanne/puppet-nfs.png?branch=master)](https://travis-ci.org/derdanne/puppet-nfs)

This module installs, configures and manages everything on NFS clients and servers.

This module is a complete refactor of the module haraldsk/nfs, because Harald Skoglund sadly is not
maintaining his module actively anymore. It is stripped down to use only the class 'nfs'
and parametrized to act as a server, client or both with the parameters 'server_enabled'
and 'client_enabled'. It also has some dependencies on newer stdlib functions like 'difference'.

It supports the OS Families Ubuntu, Debian, Redhat, SUSE, Gentoo and Archlinux. It supports also Strict Variables, so if you pass all
OS specific parameters correctly it should work on your preferred OS too. Feedback, bugreports,
and feature requests are always welcome, visit https://github.com/derdanne/puppet-nfs or send me an email.

When you are using a puppet version 3.x like it is shipped with Redhat Satellite 6, please use a version 1.x.x from puppet forge 
or the branch puppet3 when cloning directly from Github. (Note: https://github.com/derdanne/puppet-nfs/pull/49#issuecomment-285091678). 
I'll recommend using puppet >= 4.6.1, puppet versions up until 4.6.0 had various issues.

If you want to contribute, please do a fork on github, create a branch "feature name" with your
features and do a pull request.

Warning: I've introduced new dependencies with version 2.1.0 which were needed to fix buggy rpcbind-socket restarting with systemd:
- puppetlabs/transition
- herculesteam/augeasproviders_core
- herculesteam/augeasproviders_shellvar

## Setup

### What derdanne-nfs affects

This module can be used to configure your nfs client and/or server, it could export 
nfs mount resources via storeconfigs or simply mount nfs shares on a client. You can 
also easily use the create_resources function when you store your exports i.e. via hiera.

### Setup requirements

This Module depends on puppetlabs-stdlib >= 4.5.0 and puppetlabs-concat >= 1.1.2, you need to
have these modules installed to use derdanne-nfs module.

### Beginning with derdanne-nfs

On a nfs server the following code is sufficient to get all packages installed and services
running to use nfs:
```puppet
  node server {
    class { '::nfs':
      server_enabled => true,
    }
  }
```
On a client the following code is sufficient:
```puppet
  node server {
    class { '::nfs':
      client_enabled => true,
    }
  }
```

## Usage

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

```puppet
  node client {
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
  }
```


### NFSv3 multiple exports, servers and multiple node example

```puppet
  node server1 {
    class { '::nfs':
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
    class { '::nfs':
      server_enabled => true,
    }
    # ensure is passed to mount, which will make the client not mount it
    # the directory automatically, just add it to fstab
    nfs::server::export { '/media_library':
      ensure  => 'present',
      nfstag     => 'media',
      clients => '10.0.0.0/24(rw,insecure,async,no_root_squash) localhost(rw)',
    }
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
      ensure => 'mounted',
    }
  }


  # only the mount tagged as media
  # also override mount point
  node media_client {
    class { '::nfs':
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
    file { ['/data_folder', '/homeexport']:
      ensure => 'directory',
    }
    class { '::nfs':
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
    class { '::nfs':
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
    class { '::nfs':
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
    class { '::nfs':
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
    class { '::nfs':
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

### Simple create nfs export resources with hiera example

**Hiera Server Role:**

```yaml
  classes:
    - nfs

  nfs::server_enabled: true
  nfs::client_enabled :  false
  nfs::nfs_v4:  true
  nfs::nfs_v4_idmap_domain:  %{::domain}
  nfs::nfs_v4_export_root:  '/share'
  nfs::nfs_v4_export_root_clients:  '192.168.0.0/24(rw,fsid=root,insecure,no_subtree_check,async,no_root_squash)'


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

## Reference

### Classes

#### Public Classes

* [`nfs`](#class-nfs): Main class, includes all other classes

#### Public Defines

* [`nfs::client::mount`](#define-nfsclientmount): Handles all mounts on a nfs client.
* [`nfs::server::export`](#define-nfsserverexport): Handles all nfs exports on a nfs server.

#### Private Classes

* `nfs::client`: Includes all relevant classes for configuring as a client.
* `nfs::client::config`: Handles the configuration files.
* `nfs::client::package`: Handles the packages.
* `nfs::client::service`: Handles the services.

* `nfs::server`: Includes all relevant classes for configuring as a server.
* `nfs::server::config`: Handles the configuration files.
* `nfs::server::package`: Handles the packages.
* `nfs::server::service`: Handles the services.

* `nfs::params`: Includes all os specific parameters.

#### Private Defines

* `nfs::bindmount`: Creates the bindmounts of nfs 3 exports.
* `nfs::nfsv4_bindmount`: Creates the bindmounts of nfs 4 exports.
* `nfs::create_export`: Creates the nfs exports.
* `nfs::mkdir`: Creates directories recursive.

### Parameters


#### Class: `::nfs`

**The following parameters are available in the `::nfs` class:**

##### `ensure`
  String. Controls if the managed resources shall be <tt>present</tt> or
  <tt>absent</tt>. If set to <tt>absent</tt>:
  * The managed software packages are being uninstalled.
  * Any traces of the packages will be purged as good as possible. This may
    include existing configuration files. The exact behavior is provider
    dependent. Q.v.:
    * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
    * {Puppet's package provider source code}[http://j.mp/wtVCaL]
  * System modifications (if any) will be reverted as good as possible
    (e.g. removal of created users, services, changed log settings, ...).
  * This is thus destructive and should be used with care.
  Defaults to <tt>present</tt>.

##### `server_enabled`
  Boolean. If set to <tt>true</tt>, this module will configure the node
  to act as a nfs server.

##### `client_enabled`
  Boolean. If set to <tt>true</tt>, this module will configure the node
  to act as a nfs client, you can use the exported mount resources
  from configured servers.

##### `storeconfigs_enabled`
  Boolean. If set to <tt>false</tt>, this module will not export any
  resources as storeconfigs. Defaults to <tt>true</tt>.

##### `nfs_v4`
  Boolean. If set to <tt>true</tt>, this module will use nfs version 4
  for exporting and mounting nfs resources.

##### `nfs_v4_client`
  Boolean. If set to <tt>true</tt>, this module will use nfs version 4
  for mounting nfs resources. If set to <tt>false</tt> it will use nfs
  version 3 to mount nfs resources. It defaults to the setting of `nfs_v4`

##### `exports_file`
  String. It defines the location of the file with the nfs export resources used
  by the nfs server.

##### `idmapd_file`
  String. It defines the location of the file with the idmapd settings.

##### `defaults_file`
  String. It defines the location of the file with the nfs settings.

##### `manage_packages`
  Boolean. It defines if the packages should be managed through this module

##### `server_packages`
  Array. It defines the packages needed to be installed for acting as
  a nfs server

##### `server_package_ensure`
  String. It defines the packages state - any of present, installed,
  absent, purged, held, latest

##### `client_packages`
  Array. It defines the packages needed to be installed for acting as
  a nfs client

##### `client_package_ensure`
  String. It defines the packages state - any of present, installed,
  absent, purged, held, latest

##### `manage_server_service`
  Boolean. Defines if module should manage server_service

##### `manage_server_servicehelper`
  Boolean. Defines if module should manage server_servicehelper

##### `manage_client_service`
  Boolean. Defines if module should manage client_service

##### `server_service_name`
  String. It defines the servicename of the nfs server service

##### `server_service_ensure`
  Boolean. It defines the service parameter ensure for nfs server services.

##### `server_service_enable`
  Boolean. It defines the service parameter enable for nfs server service.

##### `server_service_hasrestart`
  Boolean. It defines the service parameter hasrestart for nfs server service.

##### `server_service_hasstatus`
  Boolean. It defines the service parameter hasstatus for nfs server service.

##### `server_service_restart_cmd`
  String. It defines the service parameter restart for nfs server service.

##### `server_nfsv4_servicehelper`
  Array. It defines the service helper like idmapd for servers configured with
  nfs version 4.

##### `client_services`
  Nested Hash. It defines the servicenames need to be started when acting as a nfs client

##### `client_nfsv4_services`
  Nested Hash. It defines the servicenames need to be started when acting as a nfs client
  version 4.

##### `client_service_hasrestart`
  Boolean. It defines the service parameter hasrestart for nfs client services.

##### `client_service_hasstatus`
  Boolean. It defines the service parameter hasstatus for nfs client services.

##### `client_idmapd_setting`
  Array. It defines the Augeas parameter added in `defaults_file` when acting as a nfs
  version 4 client.

##### `client_nfs_fstype`
  String. It defines the name of the nfs filesystem, when adding entries to /etc/fstab
  on a client node.

##### `client_nfs_options`
  String. It defines the options for the nfs filesystem, when adding entries to /etc/fstab
  on a client node.

##### `client_nfsv4_fstype`
  String. It defines the name of the nfs version 4 filesystem, when adding entries
  to /etc/fstab on a client node.

##### `client_nfsv4_options`
  String. It defines the options for the nfs version 4filesystem, when adding entries
  to /etc/fstab on a client node.

##### `nfs_v4_export_root`
  String. It defines the location where nfs version 4 exports should be bindmounted to
  on a server node. Defaults to <tt>/export</tt>.

##### `nfs_v4_export_root_clients`
  String. It defines the clients that are allowed to mount nfs version 4 exports and
  includes the option string. Defaults to
  <tt>*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)</tt>.

##### `nfs_v4_mount_root`
  String. It defines the location where nfs version 4 clients find the mount root
  on a server node. Defaults to <tt>/srv</tt>.

##### `nfs_v4_idmap_domain`
  String. It defines the name of the idmapd domain setting in `idmapd_file` needed
  to be set to the same value on a server and client node to do correct uid and gid
  mapping. Defaults to <tt>$::domain</tt>.

##### `nfsv4_bindmount_enable`
  Boolean. It defines if the module should create a bindmount for the export.
  Defaults to <tt>true</tt>.

##### `client_need_gssd`
  Boolean. If true, sets NEED_GSSD=yes in /etc/defauls/nfs-common, usable on Debian/Ubuntu

##### `client_gssd_service`
  Boolean. If true enable rpc-gssd service.

##### `client_gssd_options`
  String. Options for rpc-gssd service. Defaults to <tt>''</tt>

##### `client_d9_gssdopt_workaround`
  Boolean. If enabled, workaround for passing gssd_options which is broken on Debian 9. Usable only on Debian 9

##### `nfs_v4_idmap_localrealms`
  String or Array. 'Local-Realms' option for idmapd. Defaults to <tt>''</tt>

##### `nfs_v4_idmap_cache`
  Integer. 'Cache-Expiration' option for idmapd. Defaults to <tt>0</tt> - unused.

##### `manage_nfs_v4_idmap_nobody_mapping`
  Boolean. Enable setting Nobody mapping in idmapd. Defaults to <tt>false</tt>.

##### `nfs_v4_idmap_nobody_user`
  String. 'Nobody-User' option for idmapd. Defaults to <tt>nobody</tt>.

##### `nfs_v4_idmap_nobody_group`
  String. 'Nobody-Group' option for idmapd. Defaults to <tt>nobody</tt> or <tt>nogroup</tt>. 

##### `client_rpcbind_config`
  String. It defines the location of the file with the rpcbind config.

##### `client_rpcbind_optname`
  String. It defines the name of env variable that holds the rpcbind config. E.g. OPTIONS for Debian

##### `client_rpcbind_opts`
  String. Options for rpcbind service.


#### Define: `::nfs::client::mount`

**The following parameters are available in the `::nfs::client::mount` define:**

##### `server`
  String. Sets the ip address of the server with the nfs export

##### `share`
  String. Sets the name of the nfs share on the server

##### `ensure`
  String. Sets the ensure parameter of the mount.

##### `remounts`
  String. Sets the remounts parameter of the mount.

##### `atboot`
  String. Sets the atboot parameter of the mount.

##### `options_nfsv4`
  String. Sets the mount options for a nfs version 4 mount.

##### `options_nfs`
  String. Sets the mount options for a nfs mount.

##### `bindmount`
  String. When not undef it will create a bindmount on the node
  for the nfs mount.

##### `nfstag`
  String. Sets the nfstag parameter of the mount.

##### `nfs_v4`
  Boolean. When set to true, it uses nfs version 4 to mount a share.

##### `owner`
  String. Set owner of mount dir

##### `group`
  String. Set group of mount dir

##### `mode`
  String. Set mode of mount dir

##### `mount_root`
  String. Overwrite mount root if differs from server config

#### Define: `::nfs::server::export`

**The following parameters are available in the `::nfs::server::export` define:**

##### `clients`
  String. Sets the allowed clients and options for the export in the exports file.
  Defaults to <tt>localhost(ro)</tt>

##### `bind`
  String. Sets the bind options setted in /etc/fstab for the bindmounts created.
  Defaults to <tt>rbind</tt>. When you have any submounts in your exported folders,
  the rbind option will submount them in the bindmount folder. You have to set the 
  `crossmnt` option in your nfs export to have the submounts from rbind available
  on your client. Your export should look like this:
  
```puppet
node client {
  nfs::server::export { '/home':
    ensure  => 'mounted',
    clients => '*(rw,insecure,no_subtree_check,async,no_root_squash,crossmnt)',
  }
}
``` 

##### `ensure`
  String. If enabled the mount will be created. Defaults to <tt>mounted</tt>

##### `remounts`
  String. Sets the remounts parameter of the mount.

##### `atboot`
  String. Sets the atboot parameter of the mount.

##### `options_nfsv4`
  String. Sets the mount options for a nfs version 4 exported resource mount.

##### `options_nfs`
  String. Sets the mount options for a nfs exported resource mount.

##### `bindmount`
  String. When not undef it will create a bindmount on the node
  for the nfs mount.

##### `nfstag`
  String. Sets the nfstag parameter of the mount.

##### `mount`
  String. Sets the mountpoint the client will mount the exported resource mount on. If undef
  it defaults to the same path as on the server

##### `owner`
  String. Sets the owner of the exported directory

##### `group`
  String. Sets the group of the exported directory

##### `mode`
  String. Sets the permissions of the exported directory.

## Requirements

### Modules needed:

puppetlabs/stdlib >= 4.5.0
puppetlabs/concat >= 1.1.2

### Software versions needed:

facter > 1.6.2
puppet > 3.2.0

### Ruby Gems needed:

augeas

## Limitations
If you want to have specific package versions installed you may manage the needed packages outside of this 
module (use manage_packages => false). It is only tested to use 'present', 'installed', 'absent',
'purged', 'held' and 'latest' as argument for the parameters server_package_ensure and client_package_ensure.

## Development

Derdanne modules are open projects. So if you want to make this module even better,
you can contribute to this module on [Github](https://github.com/derdanne/puppet-nfs).

Before pushing PRs to Github i would recommend you to test your work locally. So you can ensure all test builds
on Travis CI were passing. I have prepared an easy way to test your code locally with the help of Docker. 

For running the complete static code analysis, it is sufficient to run a `make test-all`. 

### Default settings

I have set some defaults which you can change by setting the following environment variables.

#### PUPPET_VERSION

Changes the puppet version which will be used for the tests. Defaults to `5.0`.

#### STRICT_VARIABLES

Sets strict variables on or off. Defaults to `yes`.

#### RVM

Sets the ruby version which will be used for the tests. Defaults to `2.4.1`.

#### BEAKER_set

Sets the beaker docker target host. Defaults to `ubuntu-16.04`.

### Running tests

You can run the following commands to setup and run the testsuite on your local machine.

#### `make build`

Build a docker image with a Ruby version which is not available on Docker hub. Check out 
`https://hub.docker.com/r/derdanne/rvm/` to see if i have already prepared a rvm build for the ruby version
you want to test. Take a look at the Dockerfile located in `spec/local-testing` if you want to customize
your builds.

#### `make pull`

Pull a prebuild rvm docker image with the Ruby version defined in the variable `RVM`.

#### `make install-gems`

Install all needed gems locally to `vendor/bundle`.

#### `make test-metadata-lint`

Run linting of metadata.

#### `make test-lint`

Run puppet lint tests.

#### `make test-syntax`

Run syntax tests.

#### `make test-rspec`

Run rspec puppet tests.

#### `make test-rubocop`

Run rubocop tests.

#### `make test-all`

Run the whole testsuite.

#### `make test-beaker`

Run puppetlabs beaker rspec tests.

## Disclaimer

This module based on Harald Skoglund <haraldsk@redpill-linpro.com> from
https://github.com/haraldsk/puppet-module-nfs/ but has been fundementally refactored
