$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/71.0.3770.50/win/Opera_beta_71.0.3770.50_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/71.0.3770.50/win/Opera_beta_71.0.3770.50_Setup_x64.exe'
  checksum       = '470d76bc51305a93cd3db6dbf7ba11665cd723a9a7bedd23a556700bba681f8e'
  checksum64     = 'f0e83d352db54a436fa2741daf20d6ed9924492e9c8b8bf35f64ce027429a0ca'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '71.0.3770.50'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
