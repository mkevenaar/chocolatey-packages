$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/76.0.3974.0/win/Opera_Developer_76.0.3974.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/76.0.3974.0/win/Opera_Developer_76.0.3974.0_Setup_x64.exe'
  checksum       = 'a7aba67e708e69ee31d0479f1f7d638e6d625bbc8da6e1041e36a33eafe843a2'
  checksum64     = 'd2fb67709a86a3e094a46a92da843cf6c8f6ff0d163a151050e54528d1c778dc'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '76.0.3974.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
