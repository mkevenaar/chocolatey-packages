$ErrorActionPreference = 'Stop'; # stop on all errors
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Bitvise SSH Server*'
  fileType      = 'exe'
  silentArgs    = "-unat"
  validExitCodes= @(0, 1) # unattended uninstall exits with code 1
}

$uninstalled = $false

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | % {
    $packageArgs['file'] = "$($_.DisplayIcon)" # contains path to uninst.exe
    # uninst.exe needs product name as an additional parameter for uninstallation
    $packageArgs['silentArgs'] = "`"$($_.ProductName)`" $($packageArgs['silentArgs'])"

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
