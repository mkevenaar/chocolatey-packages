$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/78.0.4066.0/win/Opera_Developer_78.0.4066.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/78.0.4066.0/win/Opera_Developer_78.0.4066.0_Setup_x64.exe'
  checksum       = '0a2c5bd9c1e33e2682d7dbd617a69cb61254e1933d7274c696354ba4d3ef53b4'
  checksum64     = '5cdff67a99debeef418ca5e940f29693101aab904fed2c71eae5cb6c573ab50a'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '78.0.4066.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
