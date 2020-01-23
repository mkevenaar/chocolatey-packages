$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/67.0.3575.2/win/Opera_beta_67.0.3575.2_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/67.0.3575.2/win/Opera_beta_67.0.3575.2_Setup_x64.exe'
  checksum       = 'a80bd9e3aa9b16200d73fdb8375f08e01269e5a139363fe6ff3447ad1f84313f'
  checksum64     = 'dc90fb49b1e3e196aa058866ab72c169426134a64f42238dd66846cd8f345b20'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '67.0.3575.2'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
