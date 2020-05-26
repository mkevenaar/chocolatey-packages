$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/70.0.3701.0/win/Opera_Developer_70.0.3701.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/70.0.3701.0/win/Opera_Developer_70.0.3701.0_Setup_x64.exe'
  checksum       = '8eb5d26c17097f81994d20b341a02b74d6dff5f2dfb34fc81d14dc44289cc767'
  checksum64     = '8e87b2054b0087477709c50f23b79255f649380de3ada96b2e5bc494c1ff018a'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '70.0.3701.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
