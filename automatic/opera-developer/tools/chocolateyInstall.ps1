$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/87.0.4388.0/win/Opera_Developer_87.0.4388.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/87.0.4388.0/win/Opera_Developer_87.0.4388.0_Setup_x64.exe'
  checksum       = '4dfdbcc13080f025924f7211d6f3e52a4ab4e69afd74369609430a4595571f84'
  checksum64     = 'c9d2e4f9da7ef70fed3b829d58396957794869622c4e957e00a0ae6ed07473a4'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '87.0.4388.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
