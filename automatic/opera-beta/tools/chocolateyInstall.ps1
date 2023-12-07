$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/106.0.4998.6/win/Opera_beta_106.0.4998.6_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/106.0.4998.6/win/Opera_beta_106.0.4998.6_Setup_x64.exe'
  checksum       = 'e33618f94dfa7fc3d2316e258a55bb3bf9319909bcbb0959303a8a4fa3368789'
  checksum64     = 'ba8aed7db6c53be919381675657f7b57a8b07c2ef94b5aa4545ea5dc9147e941'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '106.0.4998.6'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
