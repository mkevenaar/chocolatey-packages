$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/66.0.3502.0/win/Opera_Developer_66.0.3502.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/66.0.3502.0/win/Opera_Developer_66.0.3502.0_Setup_x64.exe'
  checksum       = 'ca54829725272c286f68b16dbafbb3e7d6942d373c08c342d676e03bdf99052a'
  checksum64     = 'b4ce9dc335487b97e4c403eacadd2242f231a39d01720f646420859e0e7a687d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '66.0.3502.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
