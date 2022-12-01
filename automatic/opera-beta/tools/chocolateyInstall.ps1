$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/94.0.4606.14/win/Opera_beta_94.0.4606.14_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/94.0.4606.14/win/Opera_beta_94.0.4606.14_Setup_x64.exe'
  checksum       = '30fd881c18c90f0eb8e11217527f740e24cb9733f26cccf37061d04f5e7438a2'
  checksum64     = '73aa5ebd126ab78e3f82c1670e675a33d1657bd7f649e434f6a1be5030e2973d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '94.0.4606.14'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
