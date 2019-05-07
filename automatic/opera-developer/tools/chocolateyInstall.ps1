$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/61.0.3298.6/win/Opera_Developer_61.0.3298.6_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/61.0.3298.6/win/Opera_Developer_61.0.3298.6_Setup_x64.exe'
  checksum       = 'a390de744d5ea810e57ec3bc360263f10467dbc56e1a369f49f153acbc8cf584'
  checksum64     = '322342489ee12ae6425f60cf34d4da8773b09c5a76a6c0c4f6f76f87c96d8fa7'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '61.0.3298.6'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
