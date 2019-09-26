$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/65.0.3454.0/win/Opera_Developer_65.0.3454.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/65.0.3454.0/win/Opera_Developer_65.0.3454.0_Setup_x64.exe'
  checksum       = '95fe9aebe865e75afe4d31139b3c4894bc0418f639970b156ac4465b95b27602'
  checksum64     = '84c694f9619002eafb46eaec95695023e54184ef7f6f7b631fd6ef700dbdfd1f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '65.0.3454.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
