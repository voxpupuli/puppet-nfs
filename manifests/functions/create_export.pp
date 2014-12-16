define nfs::functions::create_export (
  $clients,
  $ensure = 'present'
) {
  if $ensure != 'absent' {
    $line = "${name} ${clients}\n"

    concat::fragment { $name:
      target  => '/etc/exports',
      content => $line
    }
  }
}