$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/97.0.4719.17/win/Opera_beta_97.0.4719.17_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/97.0.4719.17/win/Opera_beta_97.0.4719.17_Setup_x64.exe'
  checksum       = 'c337092fbd22e5a9b50ceb5ff36aef6c8183da0e7f698a20305268da145f7174'
  checksum64     = '5079198959feb60881e4cf32629edc76132ffbfd20eccb7132cc499e07c6870b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '97.0.4719.17'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
