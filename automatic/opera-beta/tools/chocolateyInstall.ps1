$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/78.0.4093.103/win/Opera_beta_78.0.4093.103_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/78.0.4093.103/win/Opera_beta_78.0.4093.103_Setup_x64.exe'
  checksum       = 'ed7db949febe7cf837a0237e0593470338c3fc7dcd9fd016b6b576eaf5b97a90'
  checksum64     = '80e4954a306de9dc3b48411d1848d4481c85c5b87068b03d170a630fb3cf0204'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '78.0.4093.103'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
