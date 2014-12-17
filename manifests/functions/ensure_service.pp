define nfs::functions::ensure_service(
  $name       = undef,
  $ensure     = stopped,
  $enable     = false,
  $hasrestart = false,
  $hasstatus  = false
){
  service { $name:
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => $hasrestart,
    hasstatus  => $hasstatus
  }
}