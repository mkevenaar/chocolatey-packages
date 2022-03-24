$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/86.0.4363.9/win/Opera_beta_86.0.4363.9_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/86.0.4363.9/win/Opera_beta_86.0.4363.9_Setup_x64.exe'
  checksum       = '234777e7b8da855ef42f1a2c5faeff1db373dff808e244527d385d09b41b63b6'
  checksum64     = 'c216365193d4e1df6ab44d6d680fcf19a1daa7ccf182b724bfe0fe09f78da16b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '86.0.4363.9'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
