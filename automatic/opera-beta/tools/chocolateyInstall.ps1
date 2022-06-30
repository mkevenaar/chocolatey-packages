$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/89.0.4447.31/win/Opera_beta_89.0.4447.31_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/89.0.4447.31/win/Opera_beta_89.0.4447.31_Setup_x64.exe'
  checksum       = 'e05851ae60fc8210ad0c38e9b3b625b18b48bf83387bd679b30ae44402ddccb0'
  checksum64     = 'a6384630765775e06a3afc385a2706f29a6b5aee8a9b8259a4faad20c6f0c8b2'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '89.0.4447.31'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
