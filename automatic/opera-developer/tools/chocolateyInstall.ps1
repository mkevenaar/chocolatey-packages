$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/111.0.5131.0/win/Opera_Developer_111.0.5131.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/111.0.5131.0/win/Opera_Developer_111.0.5131.0_Setup_x64.exe'
  checksum       = '8e8cc03514ff3cfb6090886034acbf033e5e8030663f87d2457bfc5cd1614ee6'
  checksum64     = 'e4e922512307890f4b90dcd1ba2d7f037e4788aa0bb293f7835713c4a1f1f8be'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '111.0.5131.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
