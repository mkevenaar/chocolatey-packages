$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/71.0.3749.0/win/Opera_Developer_71.0.3749.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/71.0.3749.0/win/Opera_Developer_71.0.3749.0_Setup_x64.exe'
  checksum       = '4e9c5e7fc8b8d9ed9afbe3e61b5aad9b41eba8e6792c28c6df084223b28a6e83'
  checksum64     = '2352392fe05b86c97bd7155f739f4ae391f72ba466567f5b5ece33c066a2f399'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '71.0.3749.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
