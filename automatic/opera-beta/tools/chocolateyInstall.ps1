$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/96.0.4693.16/win/Opera_beta_96.0.4693.16_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/96.0.4693.16/win/Opera_beta_96.0.4693.16_Setup_x64.exe'
  checksum       = '0591013504151225b0881496e02b13a010108e1266af1a450578d1ad0f25da15'
  checksum64     = '340b19faa5e34dc9d2f3fc334b0e83846b7461c3a38bf7ba652a60484e17b46f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '96.0.4693.16'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
