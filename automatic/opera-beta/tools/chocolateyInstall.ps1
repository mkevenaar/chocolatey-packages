$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/106.0.4998.2/win/Opera_beta_106.0.4998.2_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/106.0.4998.2/win/Opera_beta_106.0.4998.2_Setup_x64.exe'
  checksum       = '594ed08edb0375fd248bbb53a69c3effe1d269cc78cae80e78403063df6b64bd'
  checksum64     = 'cec6175ee7594cf4dccec192d9dd82285511cbe335cf530e83b1555019a1e2d6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '106.0.4998.2'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
