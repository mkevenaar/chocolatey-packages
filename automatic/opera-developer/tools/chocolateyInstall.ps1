$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/90.0.4457.0/win/Opera_Developer_90.0.4457.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/90.0.4457.0/win/Opera_Developer_90.0.4457.0_Setup_x64.exe'
  checksum       = '4aac1f1fcb395ab672408e82be9b8345a6c5efd2b608eee3bf535929d6efcc17'
  checksum64     = '9de77548d9d9bf01e324bf663cdded193d096ad8c57a635a1cf2d33590c1235c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '90.0.4457.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
