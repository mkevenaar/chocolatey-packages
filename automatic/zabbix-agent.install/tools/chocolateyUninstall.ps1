$ErrorActionPreference = 'Stop';

$PackageName  = 'zabbix-agent.install'
$SoftwareName = 'Zabbix Agent*'
$InstallerType = 'MSI'
$SilentArgs = '/qn /norestart'
$ValidExitCodes = @(0, 3010, 1605, 1614, 1641)

$Uninstalled = $false
[array]$Key = Get-UninstallRegistryKey -SoftwareName $SoftwareName

if ($Key.Count -eq 1) {
  $Key | ForEach-Object {
    $File = "$($_.UninstallString)"

    if ($InstallerType -eq 'MSI') {
      $SilentArgs = "$($_.PSChildName) $SilentArgs"
      $File = ''
    }

    Uninstall-ChocolateyPackage -PackageName $PackageName `
                                -FileType $InstallerType `
                                -SilentArgs "$SilentArgs" `
                                -ValidExitCodes $ValidExitCodes `
                                -File "$File"
  }
} elseif ($Key.Count -eq 0) {
  Write-Warning "$PackageName has already been uninstalled by other means."
} elseif ($Key.Count -gt 1) {
  Write-Warning "$Key.Count matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $Key | ForEach-Object {Write-Warning "- $_.DisplayName"}
}