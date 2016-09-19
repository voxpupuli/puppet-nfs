##2016-09-19 - Release 0.0.17
###Summary

####Features
- added set owner/group/mode of the exported directory
- rewrite testing suite

####Bugfixes
- replace ensure_resource again with "if ! defined(File[$name])"
- fix some small issues

##2016-09-08 - Release 0.0.16
###Summary

####Features
- added possibility to not manage packages by module
- added setting to manage client services
- added service notify from package resources
- added new rspec tests for service and package management
- replaced file resource with ensure_resource('file' ...)

##2016-08-26 - Release 0.0.15
###Summary

####Features
- added setting to manage services
- added setting to setup other options for package ensure
- added create folder for nfsv3
- added setting for server service restart command

####Bugfixes
- Exported resource mounts did not work

##2016-06-22 - Release 0.0.14
###Summary

####Features
- added support for Ubuntu 16.04 (xenial) and Debian 8 (jessie)

####Bugfixes
- cosmetic changes to README.md

##2016-05-02 - Release 0.0.13
###Summary

####Bugfixes
- avoid doing a delete($client_nfsv4_services, $server_nfsv4_servicehelper) when $server_nfsv4_servicehelper is undef
- some minor fixes like using absolute scopes and adding commas

####Features
- added support for Archlinux
- enhanced testing suite

##2016-04-12 - Release 0.0.12
###Summary

####Bugfixes
- remove nfs-idmap.service from $client_nfsv4_services in params.pp for RHEL 7
- add $server_nfsv4_servicehelper for Suse
- add correct testing for server_nfsv4_servicehelper in server::service
- specified correct puppet dependencies in metadata.json

##2016-01-13 - Release 0.0.11
###Summary

####Bugfixes
- update client mount to use relative devicename to "fsid=root" in nfs v4
- update client mount spec tests
- fix https://github.com/derdanne/puppet-nfs/issues/19
- update gentoo default $client_nfsv4_fstype to reflect syntax update in net-fs/nfs-utils

##2015-11-26 - Release 0.0.10
###Summary

####Bugfixes
- fixed non UTF8 char # in params.pp

####Features
- added support for openSUSE and SLES

##2015-11-06 - Release 0.0.9
###Summary

####Bugfixes
- fixed failed manual merge $mount == $name and can't be undef, we need to look at whether or not $share is undef
- fixed sharename handling
- Debian 7.9 defaults to v4

####Features
- added option to set mountpoint on exported resource

##2015-11-03 - Release 0.0.8
###Summary

####Bugfixes
- $mount == $name and can't be undef, we need to look at whether or not $share is undef

####Features
- Set perms on mounted directories
- Tested Puppet 4.2 compatibility

##2015-07-09 - Release 0.0.7
###Summary

####Bugfixes
- changed Redhat-7 service names to rpcbind.service, nfs-idmap.service, nfs-server.service
- removed nfs-lock in osfamily Debian, since this is not available and needed anymore
- removed file resource in mkdir function
- removed umlauts in my name
- removed unsupported operatingsystem release < Ubuntu 12.04

##2015-03-10 - Release 0.0.6
###Summary

####Features
- add support for OS family Redhat (CentOS, Redhat 6 ...)
- add strict variables support
- improved testing

####Bugfixes
- fixed Bug with subscription of services when using as client only module
