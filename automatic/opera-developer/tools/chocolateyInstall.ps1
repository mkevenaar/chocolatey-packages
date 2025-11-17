$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/125.0.5720.0/win/Opera_Developer_125.0.5720.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/125.0.5720.0/win/Opera_Developer_125.0.5720.0_Setup_x64.exe'
  checksum       = 'eed55885920b70794c5452096f68f371d7cc164d54fdc82e44daca8d946aa77d'
  checksum64     = '117312bd34c31dc134c71a3445d197606f5bcc7869482d83089752496228ae64'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '125.0.5720.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
