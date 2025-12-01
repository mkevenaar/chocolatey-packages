$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/126.0.5734.0/win/Opera_Developer_126.0.5734.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/126.0.5734.0/win/Opera_Developer_126.0.5734.0_Setup_x64.exe'
  checksum       = '94880bb2c1f9a09dbd59e23952510c80711b04988d2df67ed4336f0ba8c099a9'
  checksum64     = '41ed31c8dc85a2c4281a3457f9dc6487a9f7cf612ff827dcf368803b830a1ed7'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '126.0.5734.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
