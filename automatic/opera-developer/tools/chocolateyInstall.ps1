$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/105.0.4950.0/win/Opera_Developer_105.0.4950.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/105.0.4950.0/win/Opera_Developer_105.0.4950.0_Setup_x64.exe'
  checksum       = 'cd5db08c11531e16dacef7a98822d5cbeb95582c65af1700f218e9525b591e83'
  checksum64     = 'b7e4bc5f7ca282d058810f2ae2acce19c7dc92e430aeb581a8e4e1abf5c632cb'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '105.0.4950.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
