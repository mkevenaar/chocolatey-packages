$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/92.0.4561.11/win/Opera_beta_92.0.4561.11_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/92.0.4561.11/win/Opera_beta_92.0.4561.11_Setup_x64.exe'
  checksum       = '91660bba1d078480e060e73341e4e77db5a46f8f4745d61e77d6b040355238cb'
  checksum64     = '76e8300243c72afac3afe60174a502e8a8cb2aa8c9d8aa5443bdf65d941d6a9e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '92.0.4561.11'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
