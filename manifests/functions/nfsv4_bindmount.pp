define nfs::functions::nfsv4_bindmount (
  $v4_export_name,
  $bind,
  $ensure = 'mounted'
) {
  $expdir = "${nfs::server::nfs_v4_export_root}/${v4_export_name}"
  nfs::functions::mkdir { $expdir: }
  mount { $expdir:
    ensure  => $ensure,
    device  => $name,
    atboot  => true,
    fstype  => 'none',
    options => $bind,
    require => Nfs::Functions::Mkdir[$expdir],
  }
}