$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/94.0.4597.0/win/Opera_Developer_94.0.4597.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/94.0.4597.0/win/Opera_Developer_94.0.4597.0_Setup_x64.exe'
  checksum       = 'ad57f4ac401bcdc47193256a353f7fd0b69248c1d806b43269df8434d355a614'
  checksum64     = '22eebf6674d9a93722f5d43f24dccf6221665148fd67b151ea6fec7f70a11c2e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '94.0.4597.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
