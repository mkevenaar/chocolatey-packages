function Get-SlackDownloadCachePath {
  param(
    [string] $PackageName = $env:ChocolateyPackageName,
    [string] $Version = $env:ChocolateyPackageVersion
  )

  $safePackageName = if ($PackageName) { $PackageName } else { 'slack' }
  $safeVersion = if ($Version) { $Version } else { 'latest' }
  $cachePath = Join-Path -Path $env:TEMP -ChildPath "chocolatey\$safePackageName\$safeVersion"

  New-Item -Path $cachePath -ItemType Directory -Force | Out-Null
  $cachePath
}

function Get-SlackAppxVersion {
  param(
    [string] $AppxPackageName = 'com.tinyspeck.slackdesktop'
  )

  $versions = @()

  $versions += Get-AppxPackage -Name $AppxPackageName -AllUsers -ErrorAction SilentlyContinue |
    ForEach-Object { [version]$_.Version }
  $versions += Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName -eq $AppxPackageName } |
    ForEach-Object { [version]$_.Version }

  $versions | Sort-Object | Select-Object -Last 1
}

function Uninstall-SlackMsix {
  param(
    [string] $AppxPackageName = 'com.tinyspeck.slackdesktop',
    [switch] $WarnWhenMissing
  )

  $appxPackages = @(Get-AppxPackage -Name $AppxPackageName -AllUsers -ErrorAction SilentlyContinue)
  foreach ($appxPackage in $appxPackages) {
    Remove-AppxPackage -AllUsers -Package $appxPackage.PackageFullName -ErrorAction SilentlyContinue
  }

  $provisionedPackages = @(
    Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue |
      Where-Object { $_.DisplayName -eq $AppxPackageName }
  )

  foreach ($provisionedPackage in $provisionedPackages) {
    Remove-AppxProvisionedPackage -Online -PackageName $provisionedPackage.PackageName -ErrorAction SilentlyContinue
  }

  if ($WarnWhenMissing -and $appxPackages.Count -eq 0 -and $provisionedPackages.Count -eq 0) {
    Write-Warning 'Slack MSIX has already been uninstalled by other means.'
  }
}

function Uninstall-LegacySlackMsi {
  param(
    [string] $PackageName = $env:ChocolateyPackageName
  )

  $legacyMsiKeys = @(
    Get-UninstallRegistryKey -SoftwareName 'Slack*' |
      Where-Object {
        $_.PSChildName -match '^\{[0-9A-Fa-f-]{36}\}$' -and
        ($_.WindowsInstaller -eq 1 -or $_.UninstallString -match 'msiexec')
      } |
      Sort-Object -Property PSChildName -Unique
  )

  if ($legacyMsiKeys.Count -eq 0) {
    return
  }

  Write-Host 'Uninstalling legacy Slack MSI installation before provisioning MSIX.'
  Get-Process 'slack' -ErrorAction SilentlyContinue | Stop-Process -Force

  foreach ($legacyMsiKey in $legacyMsiKeys) {
    Uninstall-ChocolateyPackage -PackageName $PackageName `
                                -FileType 'msi' `
                                -SilentArgs "$($legacyMsiKey.PSChildName) /qn /norestart" `
                                -ValidExitCodes @(0, 1605, 1614, 1641, 3010) `
                                -File ''
  }
}
