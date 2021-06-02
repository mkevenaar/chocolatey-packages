$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/77.0.4054.38/win/Opera_beta_77.0.4054.38_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/77.0.4054.38/win/Opera_beta_77.0.4054.38_Setup_x64.exe'
  checksum       = '9b7aad680a0a888a8fb85239daec65b726a770d6d6ea4ef03f29956ce7acbcd2'
  checksum64     = '42394ddc9f28a4176cbe01c03cafc6c0850df5279d71108bfa3453659762941f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '77.0.4054.38'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
