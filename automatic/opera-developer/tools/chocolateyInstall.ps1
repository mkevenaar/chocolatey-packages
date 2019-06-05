$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/63.0.3340.0/win/Opera_Developer_63.0.3340.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/63.0.3340.0/win/Opera_Developer_63.0.3340.0_Setup_x64.exe'
  checksum       = '73a7c68aca550732d39e035e6cd27caee5dbcc732ccc0fded5dee8dcea1a52ee'
  checksum64     = 'bb75c1ac6a85f9e68f902793a35930eadae60890c89a95119c4b067ad87ac0e7'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '63.0.3340.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
