$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/83.0.4254.16/win/Opera_beta_83.0.4254.16_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/83.0.4254.16/win/Opera_beta_83.0.4254.16_Setup_x64.exe'
  checksum       = 'f97e91a994f4467e4e24133c17f0bf3be9838a08c99168bb0ee0caf44f1e0676'
  checksum64     = '529fc88e2a6fd277426ce203a66f7f7867b6c9dc118bce00de6f26d3727348d7'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '83.0.4254.16'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
