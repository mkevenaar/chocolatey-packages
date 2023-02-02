$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/95.0.4635.28/win/Opera_beta_95.0.4635.28_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/95.0.4635.28/win/Opera_beta_95.0.4635.28_Setup_x64.exe'
  checksum       = 'a01554eb932f45686dcd5d6ef6ee443068851105a18a70c21e48d0cdcd474767'
  checksum64     = '59d55894901d69e601f3be25b3b36bcbd84a6a4d4a409f4429f3b8bbb44b3e7d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '95.0.4635.28'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
