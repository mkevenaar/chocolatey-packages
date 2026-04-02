$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/131.0.5856.0/win/Opera_Developer_131.0.5856.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/131.0.5856.0/win/Opera_Developer_131.0.5856.0_Setup_x64.exe'
  checksum       = 'e3cbbf062b62ea6f32526f35899c92088e34cea263e1a00971e8b56ae39e5546'
  checksum64     = 'e39b009c372ea6ee3216acdd19d8f005edb7f5446014cfe64a310be5d7c9d1be'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '131.0.5856.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
