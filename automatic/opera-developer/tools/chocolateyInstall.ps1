$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/114.0.5278.0/win/Opera_Developer_114.0.5278.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/114.0.5278.0/win/Opera_Developer_114.0.5278.0_Setup_x64.exe'
  checksum       = '7a02923aa7f21b9d5c29f63474e5fc75106a43150f49735010329134e7a13fb2'
  checksum64     = 'c479c307bf1cb2cccb10db177a54ec76981a5ac84dd2618c6c311129b50e3973'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '114.0.5278.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
