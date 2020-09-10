$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/71.0.3770.126/win/Opera_beta_71.0.3770.126_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/71.0.3770.126/win/Opera_beta_71.0.3770.126_Setup_x64.exe'
  checksum       = '621504f803fea5cfc29186213b358810700dd3fe926dad1548d6db558603fa50'
  checksum64     = '44b4cd984d2851c1fb96681a2c83cb7141b1ae1a6337749cadaba245de2bbcf2'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '71.0.3770.126'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
