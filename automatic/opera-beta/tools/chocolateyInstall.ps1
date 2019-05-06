$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/60.0.3255.79/win/Opera_beta_60.0.3255.79_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/60.0.3255.79/win/Opera_beta_60.0.3255.79_Setup_x64.exe'
  checksum       = '6913da5eb93322931286362aa9d1cc4e54dbc44cd0e768f86aa942e14b232755'
  checksum64     = 'aca0cf89dfe9f7b5e47fe627cbd8d12be50605fa8910efbd93702d89b13b5769'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '60.0.3255.79'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
