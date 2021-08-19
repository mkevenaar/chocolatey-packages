$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/79.0.4143.3/win/Opera_beta_79.0.4143.3_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/79.0.4143.3/win/Opera_beta_79.0.4143.3_Setup_x64.exe'
  checksum       = '8e0ad0475877a9e5e4789e2e334cc5510257f9825f5b924acad00f5e7a473e51'
  checksum64     = '14ff9690880ad618c4628766fb5fe98204d66bb8b84e7f29258f69ba380c5374'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '79.0.4143.3'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
