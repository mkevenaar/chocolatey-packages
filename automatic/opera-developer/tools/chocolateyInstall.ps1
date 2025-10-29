$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/124.0.5701.1/win/Opera_Developer_124.0.5701.1_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/124.0.5701.1/win/Opera_Developer_124.0.5701.1_Setup_x64.exe'
  checksum       = 'f296f3f575c3f0d9e2edfbeb9eeea3892c29bead768bbc7528d83242e5ffa3d1'
  checksum64     = 'cd3bd5daac64dabdebea63d2f5772b337b83ca1027701c382179aa21f6a04874'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '124.0.5701.1'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
