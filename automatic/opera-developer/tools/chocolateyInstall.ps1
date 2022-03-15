$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/86.0.4359.0/win/Opera_Developer_86.0.4359.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/86.0.4359.0/win/Opera_Developer_86.0.4359.0_Setup_x64.exe'
  checksum       = 'f3d4d754b8c14fabc351699fa607d67149074ba8fec4ca826716b25cce995d3f'
  checksum64     = 'a85d1d1808b1262a39a78f36c564f87350c023efca3775afe008b2522691038a'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '86.0.4359.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
