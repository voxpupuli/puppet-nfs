define nfs::functions::bindmount (
  $mount_name = undef,
  $ensure = 'present'
) {
  mkdir_p { $mount_name: }
  mount { $mount_name:
    ensure  => $ensure,
    device  => $name,
    atboot  => true,
    fstype  => 'none',
    options => 'rw,bind',
    require => Mkdir_p[$mount_name]
  }
}
