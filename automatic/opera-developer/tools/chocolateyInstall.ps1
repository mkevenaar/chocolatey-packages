$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/122.0.5608.0/win/Opera_Developer_122.0.5608.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/122.0.5608.0/win/Opera_Developer_122.0.5608.0_Setup_x64.exe'
  checksum       = 'd7be074e543b88976c4b7c4aa873540a6a55b9a545db1ae51a32415c150e2a90'
  checksum64     = 'a2891eb1ccddb337e06bfe287d70efcc16daca1044ccca530ec1e9cc9c141211'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '122.0.5608.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
