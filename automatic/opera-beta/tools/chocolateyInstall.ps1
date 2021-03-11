$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/75.0.3969.50/win/Opera_beta_75.0.3969.50_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/75.0.3969.50/win/Opera_beta_75.0.3969.50_Setup_x64.exe'
  checksum       = 'a570e21dddccddbba1df3f908069c58eaa241d7d9f45e97650e64cd960e318c7'
  checksum64     = '746ba43eb8c316f245095255e98a88f31ca020e6ec8e421fa5252e897520bf7f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '75.0.3969.50'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
