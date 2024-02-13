$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/109.0.5076.0/win/Opera_Developer_109.0.5076.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/109.0.5076.0/win/Opera_Developer_109.0.5076.0_Setup_x64.exe'
  checksum       = 'd36677762abad55faef5e441738271594922d91308a37930fcf0774e8e9fc4a9'
  checksum64     = 'eff75d968e7525659e9703ce0e72d67744430af49d4a897fcc50d408c1629b8b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '109.0.5076.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
