Get-ChildItem | Where-Object PSIsContainer | Where-Object { !(Test-Path $_\README.md) } | ForEach-Object {
  [xml] $package = Get-Content $_\*.nuspec -ea 0 -Encoding UTF8
  if (!$package) { return }

  $meta = $package.package.metadata
  $readme = ('# <img src="{1}" width="48" height="48"/> [{0}](https://chocolatey.org/packages/{0})' -f $meta.id, $meta.iconUrl), ''
  $readme += $meta.description -split "`n" | ForEach-Object { $_.Trim() }
  $readme -join "`n" | Out-File -Encoding UTF8 $_\README.md
  $meta.id
}
