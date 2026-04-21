# @summary Manage directory creation.
#
# @param ensure
# @param umask
#
# @author
#   * Daniel Klockenkaemper <dk@marketing-factory.de>
#   * Martin Alfke <tuxmea@gmail.com>
#
define nfs::functions::mkdir (
  String[1] $ensure = 'present',
  Optional[Stdlib::Filemode] $umask  = undef,
) {
  if $ensure != 'absent' {
    $_command = $umask ? {
      undef   => "mkdir -p ${name}",
      default => "bash -c 'umask ${umask} && mkdir -p ${name}'",
    }

    exec { "mkdir_recurse_${name}":
      path    => ['/bin', '/usr/bin'],
      command => $_command,
      unless  => "test -d ${name}",
    }
  }
}
