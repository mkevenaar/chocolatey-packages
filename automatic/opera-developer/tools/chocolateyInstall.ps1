$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/111.0.5145.0/win/Opera_Developer_111.0.5145.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/111.0.5145.0/win/Opera_Developer_111.0.5145.0_Setup_x64.exe'
  checksum       = 'c200526da5f699debe9674f9d260b5309195d47fcb4f2d7db8934803f733ef8a'
  checksum64     = '3874cf7b8d55fe7d5ac272c59b454186a0d9a5ab0c0043f15950f404b6728816'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '111.0.5145.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
