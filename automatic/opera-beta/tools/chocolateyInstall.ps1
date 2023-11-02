$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/105.0.4970.6/win/Opera_beta_105.0.4970.6_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/105.0.4970.6/win/Opera_beta_105.0.4970.6_Setup_x64.exe'
  checksum       = '5e0236e11d02402201da702e2882a89d195a140b27402bfd46468903c1beb1c3'
  checksum64     = '804df16158286dfc5f4c07bbd95167dc4e40bdca16463f6a1568e9430f306a24'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '105.0.4970.6'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
