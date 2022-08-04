$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/90.0.4480.37/win/Opera_beta_90.0.4480.37_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/90.0.4480.37/win/Opera_beta_90.0.4480.37_Setup_x64.exe'
  checksum       = '7745c5898fdadd8fb98bc4e01a4e4cf67436f8f732df92408698c256ec4ac655'
  checksum64     = 'ae5ad2d200c1b01a5c5e85ad873b47609b41277b2da5db46334687d291f1f196'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '90.0.4480.37'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
