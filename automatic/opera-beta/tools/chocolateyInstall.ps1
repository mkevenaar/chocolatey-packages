$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/107.0.5045.11/win/Opera_beta_107.0.5045.11_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/107.0.5045.11/win/Opera_beta_107.0.5045.11_Setup_x64.exe'
  checksum       = '6614c4d9d6ca95258e257490b8c5550b3cc793f8db931e8b3285fce86c0e4f90'
  checksum64     = '7a08f19a6f8f5cd1d0bfd91de40f6983c526c28d97f6b5ec0c114d0adf281763'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '107.0.5045.11'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
