$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/81.0.4175.0/win/Opera_Developer_81.0.4175.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/81.0.4175.0/win/Opera_Developer_81.0.4175.0_Setup_x64.exe'
  checksum       = '079702eec2442da966c496352338798d303d1f750d29328087e650f525d5adba'
  checksum64     = '4c51ea44309c4690a168b8a77e5327dae1e5c60a6d21d60c2140c146d82cc494'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '81.0.4175.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
