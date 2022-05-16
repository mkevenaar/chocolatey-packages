$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/89.0.4422.0/win/Opera_Developer_89.0.4422.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/89.0.4422.0/win/Opera_Developer_89.0.4422.0_Setup_x64.exe'
  checksum       = 'b4a13cea1634ecc5db352a062d122f061565b2d30a32d23259f2e2f43071c43f'
  checksum64     = '98b4df5ff0a16065763305462ea8946d168c23e286caa95042f3cd3499f99576'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '89.0.4422.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
