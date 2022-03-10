$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/85.0.4341.10/win/Opera_beta_85.0.4341.10_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/85.0.4341.10/win/Opera_beta_85.0.4341.10_Setup_x64.exe'
  checksum       = '634a05cf75e045fd53851ca274ebbb80d8555cb2383a8c583349c218ab1b8cce'
  checksum64     = '415f1f4c246e65a2ea535b28130fdf6cad1c84010835da130222b38456db75e0'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '85.0.4341.10'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
