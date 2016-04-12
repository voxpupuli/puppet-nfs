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
