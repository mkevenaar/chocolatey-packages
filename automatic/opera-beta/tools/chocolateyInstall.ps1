$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/72.0.3815.86/win/Opera_beta_72.0.3815.86_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/72.0.3815.86/win/Opera_beta_72.0.3815.86_Setup_x64.exe'
  checksum       = 'e761ea53f4511e755919843230bf5b5ce48fdf20a3a25e764d27b2c4de6e5b06'
  checksum64     = 'e65c5569b3a068c9ac33c8bd7e403de48650b12e5b9001f7123db70dd0eec4f6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '72.0.3815.86'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
