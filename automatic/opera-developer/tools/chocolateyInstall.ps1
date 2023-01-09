$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/96.0.4660.0/win/Opera_Developer_96.0.4660.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/96.0.4660.0/win/Opera_Developer_96.0.4660.0_Setup_x64.exe'
  checksum       = '2fbc64a3be20e5301c0155741ae3a1b39fd137a03645ffcaf90cb2309af77101'
  checksum64     = 'f1da8538024a898ca157007eca7012f4fd4344102fbd2707fcfff016c79e88da'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '96.0.4660.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
