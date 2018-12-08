$ErrorActionPreference = 'Stop'; # stop on all errors

$packageArgs = @{
  PackageName     = $env:ChocolateyPackageName
  softwareName    = "JetBrains GoLand*"
  FileType        = 'exe'
  Silent          = '/S'
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | % {
    $packageArgs['file'] = "$($_.UninstallString)"
    Get-Process PyCharm* | % { $_.CloseMainWindow() }
    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}
