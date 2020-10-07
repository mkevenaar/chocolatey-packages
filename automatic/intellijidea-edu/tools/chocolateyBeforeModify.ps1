$ErrorActionPreference = 'Stop'; # stop on all errors

$packageArgs = @{
  PackageName     = $env:ChocolateyPackageName
  softwareName    = "PyCharm Edu*"
  FileType        = 'exe'
  Silent          = '/S'
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | ForEach-Object {
    $packageArgs['file'] = "$($_.UninstallString)"
    Get-Process PyCharm* | ForEach-Object { $_.CloseMainWindow() }
    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | ForEach-Object {Write-Warning "- $($_.DisplayName)"}
}
