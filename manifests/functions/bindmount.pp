define nfs::functions::bindmount (
  $mount_name = undef,
  $ensure = 'present'
) {
  nfs::functions::mkdir { $mount_name: }
  mount { $mount_name:
    ensure  => $ensure,
    device  => $name,
    atboot  => true,
    fstype  => 'none',
    options => 'rw,bind',
    require => Nfs::Functions::Mkdir[$mount_name]
  }
}
