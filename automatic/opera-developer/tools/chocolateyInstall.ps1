$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/63.0.3359.0/win/Opera_Developer_63.0.3359.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/63.0.3359.0/win/Opera_Developer_63.0.3359.0_Setup_x64.exe'
  checksum       = 'abc025bdaab5ec2412c8e3e58be22c57eed54a0192a83a68d8f35371d364f0f0'
  checksum64     = 'c8db66c8d28e6c8098d076a807c9de0d1febce94690505f1b6838c3e510ad471'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '63.0.3359.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
