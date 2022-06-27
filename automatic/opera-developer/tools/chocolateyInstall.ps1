$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/90.0.4463.0/win/Opera_Developer_90.0.4463.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/90.0.4463.0/win/Opera_Developer_90.0.4463.0_Setup_x64.exe'
  checksum       = '8ef35eed8d5e241b4e7be0d8d0f49dbe2793a9ba6a3132ec728ed33a1c55c564'
  checksum64     = '1f406aa2fae8970b3ceaa6186b8bb556211ae9262304866191ce01c06805e97f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '90.0.4463.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
