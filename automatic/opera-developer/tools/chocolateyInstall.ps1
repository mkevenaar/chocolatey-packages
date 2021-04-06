$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/76.0.4016.0/win/Opera_Developer_76.0.4016.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/76.0.4016.0/win/Opera_Developer_76.0.4016.0_Setup_x64.exe'
  checksum       = '82e9381a15721bcc35f01af372a76576604cff9f41279458a60ea15c7527834c'
  checksum64     = 'd10459ac3353b787731a38917481ea7b558e5e5004c29ef05076f0deed574ab3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '76.0.4016.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
