$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/93.0.4585.7/win/Opera_beta_93.0.4585.7_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/93.0.4585.7/win/Opera_beta_93.0.4585.7_Setup_x64.exe'
  checksum       = '45cd11bcfa25ed5dab520ef60e3a1f35709437a345f767d2320bf694b73818c9'
  checksum64     = 'd91f54fc8338c7d50b7e57cf451970910a3f5fc1728b0a777e67c7845e81e035'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '93.0.4585.7'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
