$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. $toolsDir\helpers.ps1

[version] $softwareVersion = '117.0.0.0'
$installedVersion = Get-InstalledVersion

if ($installedVersion -eq $softwareVersion -and !$env:ChocolateyForce) {
  Write-Output "Google Drive $version is already installed. Skipping download and installation."
}
else {
  if ($softwareVersion -le $installedVersion) {
    Write-Output "Current installed version (v$installedVersion) must be uninstalled first..."
    Uninstall-CurrentVersion
    throw 'Windows must be rebooted before installation can be completed!'
  }

  $url = 'https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe'
  $checksum = 'BCC48DE9E2FFCD4DE1AE0E18C926100C81EF5F4B279DE00595C1C0A16B99C95B'
  $checksumType = 'sha256'

  $packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = $url
    checksum       = $checksum
    checksumType   = $checksumType
    softwareName   = 'Google Drive*'
    silentArgs     = "--silent"
    validExitCodes = @(0, 1641, 3010)
  }

  $pp = Get-PackageParameters
  if ($pp.NoStart) {
    $packageArgs['silentArgs'] += ' --skip_launch_new'
  }
  if ($pp.NoDesktopIcon) {
    $packageArgs['silentArgs'] += ' --desktop_shortcut=false'
  } else {
    $packageArgs['silentArgs'] += ' --desktop_shortcut'
  }
  if ($pp.NoGsuiteIcons) {
    $packageArgs['silentArgs'] += ' --gsuite_shortcuts=false'
  }

  Install-ChocolateyPackage @packageArgs
}
