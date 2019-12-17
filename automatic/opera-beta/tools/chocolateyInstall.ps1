$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/66.0.3515.14/win/Opera_beta_66.0.3515.14_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/66.0.3515.14/win/Opera_beta_66.0.3515.14_Setup_x64.exe'
  checksum       = 'b0b459f02cae66d8cd62b03f269087eeb9037291288a2cb88945905178baebb9'
  checksum64     = 'b5bbc1abbed739e0d53678efceefabf45bd33662bdb9838ac0a4923e832bd048'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '66.0.3515.14'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
