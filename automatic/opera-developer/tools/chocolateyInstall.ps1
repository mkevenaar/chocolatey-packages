$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/105.0.4963.0/win/Opera_Developer_105.0.4963.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/105.0.4963.0/win/Opera_Developer_105.0.4963.0_Setup_x64.exe'
  checksum       = '447f8e9c7946a00a015097f3c83a57849fc6d42c5d0b22f33c61955e0655e869'
  checksum64     = 'b5800f4ee86052aa83b7c951c118a35bf3c7fb293ecab44c71e03e58d723cefb'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '105.0.4963.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
