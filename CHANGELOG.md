## 2019-02-12 - Release 2.1.2
### Summary

#### Features
- herculesteam-augeasprovides_shellvar has been updated to 3.0.0 

## 2019-02-12 - Release 2.1.1
### Summary

#### Bugfixes
- Dependencies requirements were blocking update/install from the puppet forge

## 2019-02-08 - Release 2.1.0
### Summary

#### Bugfixes
- do not change SELinux context in bindmounts
- change syntax in create_exports for compatibilty
- fix stuck on restart rpcbind-socket for RHEL

#### Features
- allow stdlib and concat in versions <6.0.0
- add flag to disable bindmounts for nfs v4
- add idmapd, rpcbind and gssd options

## 2018-10-09 - Release 2.0.10
### Summary

#### Bugfixes
- fix service management for Ubuntu 18.04 bionic
- moved back to use nfs-kernel-server on Debian for compatibility

#### Features
- add testing against Puppet 6

## 2018-07-10 - Release 2.0.9
### Summary

#### Features
- add support for Ubuntu 18.04 bionic
- add testsuite for ubuntu 18.04 bionic

#### Bugfixes
- fix service helpers on Ubuntu 14.04 trusty

## 2018-05-18 - Release 2.0.8
### Summary

#### Bugfixes
- update rubocop configuration for version >= 0.53.0 of RuboCop
- according to https://access.redhat.com/solutions/209553 do not enable rpcidmapd on RHEL 7

#### Features
- add server parameter to export define type
- add easy local testing with beaker and docker

## 2018-02-21 - Release 2.0.7
### Summary

#### Bugfixes
- disable manage of resource $::nfs::idmapd_file for nfsv3 server

## 2017-12-14 - Release 2.0.6
### Summary

#### Bugfixes
- set rpcbind enable to false and running to true to work around systemd status indirect for debian based os with systemd
- update documentation for $server_nfsv4_servicehelper
- update puppet-lint task
- fix rubocop testing

## 2017-10-10 - Release 2.0.5
### Summary

#### Bugfixes
- set $nfs_v4_idmap_domain to 'example.org' when $::domain is undef
- add client service rpcbind.socket for RedHat 7
- set client service rpcbind.service for RedHat 7 to enable => false
- fix service parameters for Debian 7 

#### Features
- update rubocop rules and fix ruby code style
- change type of server_nfsv4_servicehelper to array for allowing multiple helper services
- add acceptance tests for CentOs 6 and 7 and Debian 7 and 8
- add acceptance tests for nfs configured as client
- add testing with Puppet v5

## 2017-07-11 - Release 2.0.4
### Summary

#### Bugfixes
- fix markdown formatting of README.md
- fix ruby formatting in spec tests
- update puppetlabs/concat dependency
- add install locales on ubuntu-1604 docker for acceptance tests
- add missing documentation for client_services_enable
- reenable client_services_enable for CentOS/Redhat 7
- remove rpc.idmapd from $client_nfsv4_services for Archlinux 
- rename rpc.idmapd to nfs-idmapd in $server_nfsv4_servicehelper for archlinux
- update adn fix spec tests

#### Features
- add use of $::nfs::exports_file instead of fixed filepath
- add Ubuntu Yakkety and Zesty
- add support of Debian 9
- update testmatrix
- update data type for $exports_file, $idmapd_file and $defaults_file to Stdlib::Absolutepath

## 2017-03-22 - Release 2.0.3
### Summary

#### Bugfixes
- fix systemd indirect status for rpcbind on RHEL7
- replace idmapd service by nfs-common service on Debian Jessie

## 2017-03-09 - Release 2.0.2
### Summary

#### Bugfixes
- add require of client packages for client::mount mount resource

## 2017-03-09 - Release 2.0.1
### Summary

#### Features
- add parameter storeconfigs_enabled to optionally disable exporting resources

## 2017-03-09 - Release 2.0.0
### Summary

#### Features
- drop puppet 3 support on master branch (note: https://github.com/derdanne/puppet-nfs/pull/49#issuecomment-285091678)
- apply additional rubocop rules
- replace all validate functions with datatypes

## 2016-11-24 - Release 1.0.2
### Summary

#### Features
- updated documentation
- added acceptance tests with rspec-beaker

## 2016-09-19 - Release 1.0.1
### Summary

#### Features
- updated documentation
- refactor testing suite

## 2016-09-19 - Release 0.0.17
### Summary

#### Features
- added set owner/group/mode of the exported directory
- rewrite testing suite

#### Bugfixes
- replace ensure_resource again with "if ! defined(File[$name])"
- fix some small issues

## 2016-09-08 - Release 0.0.16
### Summary

#### Features
- added possibility to not manage packages by module
- added setting to manage client services
- added service notify from package resources
- added new rspec tests for service and package management
- replaced file resource with ensure_resource('file' ...)

## 2016-08-26 - Release 0.0.15
### Summary

#### Features
- added setting to manage services
- added setting to setup other options for package ensure
- added create folder for nfsv3
- added setting for server service restart command

#### Bugfixes
- Exported resource mounts did not work

## 2016-06-22 - Release 0.0.14
### Summary

####Features
- added support for Ubuntu 16.04 (xenial) and Debian 8 (jessie)

#### Bugfixes
- cosmetic changes to README.md

## 2016-05-02 - Release 0.0.13
### Summary

#### Bugfixes
- avoid doing a delete($client_nfsv4_services, $server_nfsv4_servicehelper) when $server_nfsv4_servicehelper is undef
- some minor fixes like using absolute scopes and adding commas

#### Features
- added support for Archlinux
- enhanced testing suite

## 2016-04-12 - Release 0.0.12
### Summary

#### Bugfixes
- remove nfs-idmap.service from $client_nfsv4_services in params.pp for RHEL 7
- add $server_nfsv4_servicehelper for Suse
- add correct testing for server_nfsv4_servicehelper in server::service
- specified correct puppet dependencies in metadata.json

## 2016-01-13 - Release 0.0.11
### Summary

#### Bugfixes
- update client mount to use relative devicename to "fsid=root" in nfs v4
- update client mount spec tests
- fix https://github.com/derdanne/puppet-nfs/issues/19
- update gentoo default $client_nfsv4_fstype to reflect syntax update in net-fs/nfs-utils

## 2015-11-26 - Release 0.0.10
### Summary

#### Bugfixes
- fixed non UTF8 char # in params.pp

#### Features
- added support for openSUSE and SLES

## 2015-11-06 - Release 0.0.9
### Summary

#### Bugfixes
- fixed failed manual merge $mount == $name and can't be undef, we need to look at whether or not $share is undef
- fixed sharename handling
- Debian 7.9 defaults to v4

#### Features
- added option to set mountpoint on exported resource

## 2015-11-03 - Release 0.0.8
### Summary

#### Bugfixes
- $mount == $name and can't be undef, we need to look at whether or not $share is undef

#### Features
- Set perms on mounted directories
- Tested Puppet 4.2 compatibility

## 2015-07-09 - Release 0.0.7
### Summary

#### Bugfixes
- changed Redhat-7 service names to rpcbind.service, nfs-idmap.service, nfs-server.service
- removed nfs-lock in osfamily Debian, since this is not available and needed anymore
- removed file resource in mkdir function
- removed umlauts in my name
- removed unsupported operatingsystem release < Ubuntu 12.04

## 2015-03-10 - Release 0.0.6
### Summary

#### Features
- add support for OS family Redhat (CentOS, Redhat 6 ...)
- add strict variables support
- improved testing

#### Bugfixes
- fixed Bug with subscription of services when using as client only module
