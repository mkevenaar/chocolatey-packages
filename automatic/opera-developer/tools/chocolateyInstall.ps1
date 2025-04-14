$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/120.0.5502.0/win/Opera_Developer_120.0.5502.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/120.0.5502.0/win/Opera_Developer_120.0.5502.0_Setup_x64.exe'
  checksum       = '87f99dad0ace9e9f1aa760283303ff93d8f52c9e8ae54f7f0449c36637cf0e34'
  checksum64     = '3df86b38d2fc5f8cc3be05f93fe0a4953e6c8ba10f9cdd6f2664445e13bb6b4b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '120.0.5502.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
