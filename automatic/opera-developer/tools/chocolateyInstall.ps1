$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/85.0.4338.0/win/Opera_Developer_85.0.4338.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/85.0.4338.0/win/Opera_Developer_85.0.4338.0_Setup_x64.exe'
  checksum       = 'f569b85de8808ae0bd069a14d2773285ba5deef944e7d67fcca3d5fc04bc8c2a'
  checksum64     = 'dc01749326e881b24d1c96167be36a1c48fef8e5be50b56ac018bf40b88b9d15'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '85.0.4338.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
