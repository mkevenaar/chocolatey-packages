$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/86.0.4363.17/win/Opera_beta_86.0.4363.17_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/86.0.4363.17/win/Opera_beta_86.0.4363.17_Setup_x64.exe'
  checksum       = 'ca6b15f2317622ff68bd58b28e547f4c1581cfe20f8789cd132b9032f0b2da11'
  checksum64     = 'f93a6ecdb7782cf515d6ddd8ee31a6c153cefb6481ca01f108bbf1832e280253'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '86.0.4363.17'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
