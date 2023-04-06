$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/98.0.4759.1/win/Opera_beta_98.0.4759.1_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/98.0.4759.1/win/Opera_beta_98.0.4759.1_Setup_x64.exe'
  checksum       = '04168081881ac17551437548b7bd91ff0171049cb9d95bfbd2de8a27236e64aa'
  checksum64     = '7052cf4e3fb10aa3c54a3fae448dc3ba1132ea1c29412bed7dd1202a8232944b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '98.0.4759.1'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
