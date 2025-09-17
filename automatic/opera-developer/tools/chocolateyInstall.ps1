$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/123.0.5658.0/win/Opera_Developer_123.0.5658.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/123.0.5658.0/win/Opera_Developer_123.0.5658.0_Setup_x64.exe'
  checksum       = '4f62ea47bac108ff5fd2a6f159239bba35bfbdd01d3926051e3af200a2d53a93'
  checksum64     = 'b06cd6307f3087af1cbf4dbe020046a767f8c26b1c42211fa3288cfeabc3b55c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '123.0.5658.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
