$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/77.0.4054.14/win/Opera_beta_77.0.4054.14_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/77.0.4054.14/win/Opera_beta_77.0.4054.14_Setup_x64.exe'
  checksum       = '9c632cbbd691baa10c6e09ab706f16d2a8d0adf65dfc8a7a97d68bda96f68901'
  checksum64     = '7891a6e3e6576a0d7e8546ad9a5d5d60beb34c9327141ba7f428e8759aec3a83'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '77.0.4054.14'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
