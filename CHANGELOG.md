# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v4.0.0](https://github.com/voxpupuli/puppet-nfs/tree/v4.0.0) (2025-12-11)

[Full Changelog](https://github.com/voxpupuli/puppet-nfs/compare/v3.0.0...v4.0.0)

**Breaking changes:**

- Drop EOL Ubuntu 20.04, RedHat 7, CentOS 8 [\#230](https://github.com/voxpupuli/puppet-nfs/pull/230) ([kenyon](https://github.com/kenyon))
- Drop puppet, update openvox minimum version to 8.19 [\#221](https://github.com/voxpupuli/puppet-nfs/pull/221) ([TheMeier](https://github.com/TheMeier))
- 🔥 remove EOL SLES/OpenSUSE version and ✨ add currrent SLES/OpenSUSE version [\#219](https://github.com/voxpupuli/puppet-nfs/pull/219) ([thomas-merz](https://github.com/thomas-merz))

**Implemented enhancements:**

- Add Debian 13 & AlmaLinux & Rocky & OracleLinux support [\#227](https://github.com/voxpupuli/puppet-nfs/pull/227) ([bastelfreak](https://github.com/bastelfreak))
- Add RHEL/CentOS 10 support [\#225](https://github.com/voxpupuli/puppet-nfs/pull/225) ([cmd-ntrf](https://github.com/cmd-ntrf))
- Add support for Debian 12 [\#223](https://github.com/voxpupuli/puppet-nfs/pull/223) ([smortex](https://github.com/smortex))
- metadata.json: Add OpenVox [\#217](https://github.com/voxpupuli/puppet-nfs/pull/217) ([jstraw](https://github.com/jstraw))
- Allow export clients to be Array [\#213](https://github.com/voxpupuli/puppet-nfs/pull/213) ([moritz-makandra](https://github.com/moritz-makandra))
- Add Ubuntu 24.04 support [\#204](https://github.com/voxpupuli/puppet-nfs/pull/204) ([bastelfreak](https://github.com/bastelfreak))
- Option for create nfs exported directory [\#186](https://github.com/voxpupuli/puppet-nfs/pull/186) ([bschonec](https://github.com/bschonec))

**Closed issues:**

- Refactor `params.pp` to move case OS family-code into hiera files [\#211](https://github.com/voxpupuli/puppet-nfs/issues/211)
- Missing condition for server\_nfsv4\_servicehelper for ubuntu 24 \(noble\) distribution [\#208](https://github.com/voxpupuli/puppet-nfs/issues/208)
- Allow creating the export without having to create the directory. [\#184](https://github.com/voxpupuli/puppet-nfs/issues/184)
- add support for puppet-augeasproviders\_core 4.X and puppet-augeasproviders\_shellvar \> 6.x [\#176](https://github.com/voxpupuli/puppet-nfs/issues/176)
- Support Puppet Stdlib 9.x [\#168](https://github.com/voxpupuli/puppet-nfs/issues/168)

**Merged pull requests:**

- README: fix resource creation example [\#236](https://github.com/voxpupuli/puppet-nfs/pull/236) ([kenyon](https://github.com/kenyon))
- Replace stdlib `delete` and `difference` functions with built-in operator [\#235](https://github.com/voxpupuli/puppet-nfs/pull/235) ([kenyon](https://github.com/kenyon))
- `metadata.json`: remove `augeas_core` and `mount_core` [\#234](https://github.com/voxpupuli/puppet-nfs/pull/234) ([kenyon](https://github.com/kenyon))
- docs, tests: update obsolete syntax [\#233](https://github.com/voxpupuli/puppet-nfs/pull/233) ([kenyon](https://github.com/kenyon))
- README cleanup [\#232](https://github.com/voxpupuli/puppet-nfs/pull/232) ([kenyon](https://github.com/kenyon))
- Remove unused/obsolete `spec/local-testing` files and docs [\#231](https://github.com/voxpupuli/puppet-nfs/pull/231) ([kenyon](https://github.com/kenyon))
- Unit test refactor: use `on_supported_os` from rspec-puppet-facts [\#229](https://github.com/voxpupuli/puppet-nfs/pull/229) ([kenyon](https://github.com/kenyon))
- Rework documentation into Puppet Strings format [\#212](https://github.com/voxpupuli/puppet-nfs/pull/212) ([Safranil](https://github.com/Safranil))
- Migrate from `params.pp` to hiera data [\#194](https://github.com/voxpupuli/puppet-nfs/pull/194) ([tuxmea](https://github.com/tuxmea))

## [v3.0.0](https://github.com/voxpupuli/puppet-nfs/tree/v3.0.0) (2024-08-06)

[Full Changelog](https://github.com/voxpupuli/puppet-nfs/compare/v2.1.11...v3.0.0)

**Breaking changes:**

- Drop Debian 10 support [\#203](https://github.com/voxpupuli/puppet-nfs/pull/203) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add CentOS 8/9 support [\#200](https://github.com/voxpupuli/puppet-nfs/pull/200) ([bastelfreak](https://github.com/bastelfreak))
- Add RedHat 9 support [\#199](https://github.com/voxpupuli/puppet-nfs/pull/199) ([bastelfreak](https://github.com/bastelfreak))
- move static data from params.pp to init.pp [\#198](https://github.com/voxpupuli/puppet-nfs/pull/198) ([bastelfreak](https://github.com/bastelfreak))
- Add Puppet 8 compatibility [\#178](https://github.com/voxpupuli/puppet-nfs/pull/178) ([tuxmea](https://github.com/tuxmea))

**Merged pull requests:**

- puppet-lint: validate types and documentation [\#206](https://github.com/voxpupuli/puppet-nfs/pull/206) ([bastelfreak](https://github.com/bastelfreak))
- Remove data for EoL operating systems [\#202](https://github.com/voxpupuli/puppet-nfs/pull/202) ([bastelfreak](https://github.com/bastelfreak))
- Delete legacy nodesets [\#201](https://github.com/voxpupuli/puppet-nfs/pull/201) ([bastelfreak](https://github.com/bastelfreak))
- README.md: Add badges and transfer notice [\#196](https://github.com/voxpupuli/puppet-nfs/pull/196) ([bastelfreak](https://github.com/bastelfreak))
- lint auto fix [\#191](https://github.com/voxpupuli/puppet-nfs/pull/191) ([tuxmea](https://github.com/tuxmea))

## [v2.1.11](https://github.com/voxpupuli/puppet-nfs/tree/v2.1.11) (2023-03-02)

### Summary

#### Features
- update rubocop ruleset

#### Bugfixes
- fix packaging
- fix rubocop testing

## 2020-06-08 - Release 2.1.5
### Summary

#### Features
- add support for Ubuntu 20.04 Focal
- update rubocop ruleset

## 2020-04-26 - Release 2.1.4
### Summary

#### Bugfixes
- fix rubocop testing
- set explicit spec_helper mock_with config to :rspec
- set correct server_nfsv4_servicehelper for Redhat 8
- make sure $clients will be type array

## 2020-03-29 - Release 2.1.3
### Summary

#### Features
- add beaker set for debian 9
- update beaker
- do not allow puppet 6 rspec tests to fail
- remove deprecated ubuntu-14.04 from acceptance test suite
- add Debian 10 (Buster) support
- dependencies: bump hercules-team/augeasproviders_shellvar
- update dependencies for stdlib and concat
- make nfs::server::export parameter "clients" work with an array or a string
- add RHEL8 configuration, based off the previous "7.5 and above" config
- add RedHat 8 rspec tests

#### Bugfixes
- use native filter function instead of delete_undef_values
- fix puppet 6 spec tests
- fix linter tests
- fix rubocop cop names
- fix beaker rspec for debian-7 and debian-8
- fix options name typo in README
- ignore export root when bindmount is disabled
- use BEAKER_PUPPET_COLLECTION in all beaker tests
- do not include class by absolute name
- revert use of File without defined()
- update rvm to 2.4.1 for PUPPET_VERSION 4.10.0

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


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
