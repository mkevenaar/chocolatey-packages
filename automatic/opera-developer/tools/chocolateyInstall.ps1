$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/108.0.5054.0/win/Opera_Developer_108.0.5054.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/108.0.5054.0/win/Opera_Developer_108.0.5054.0_Setup_x64.exe'
  checksum       = '11afd16411ec39cab40d77cfc55063901c5387402508fa10e298204d614d49e2'
  checksum64     = '8219f1caa842add41515d4991c4f048c191e9163cdbe6fa9b9d5f9fce58986f1'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '108.0.5054.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
