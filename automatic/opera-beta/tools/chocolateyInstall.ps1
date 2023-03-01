$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/97.0.4719.4/win/Opera_beta_97.0.4719.4_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/97.0.4719.4/win/Opera_beta_97.0.4719.4_Setup_x64.exe'
  checksum       = 'f88c5bf96eb8580bac4f0d2b2536408c5b459de042cccbb19b51e8198ee9fead'
  checksum64     = 'e73ceafdf728bd4d92cbfbfa81af1386e4cc0701d5e8ceb19a74e68d88aa4d5c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '97.0.4719.4'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
