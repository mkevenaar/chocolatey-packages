$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/64.0.3417.8/win/Opera_beta_64.0.3417.8_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/64.0.3417.8/win/Opera_beta_64.0.3417.8_Setup_x64.exe'
  checksum       = '7f3c091554dde043a44fe69427e9f3b7ce65dea6fbc389050a875e9555f598a1'
  checksum64     = 'dde3919a954725c98a829c75e67ce106bd69d7ec264395268e153eefbf2eea5d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '64.0.3417.8'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
