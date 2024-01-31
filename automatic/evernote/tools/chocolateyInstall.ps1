$ErrorActionPreference = 'Stop'

$osInfo = Get-WmiObject Win32_OperatingSystem | Select-Object Version, ProductType, Caption, OperatingSystemSKU, BuildNumber

Write-host "Detected: $($osInfo.Caption)" -ForegroundColor Cyan

$osInfo.Version = [version]$osInfo.Version
if ($osInfo.Version -lt [version]'6.1') {
   Throw 'Evernote requires Windows 7 or later.'
}
elseif ($osInfo.ProductType -ne 1) {
   Throw 'Evernote cannot be installed on Windows Server.'
}

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://win.desktop.evernote.com/builds/Evernote-latest.exe'
$checksum     = '741B1AF5FD088948DE05B0A6A8E6ABE009B10CA144DB2A4CA2A39EEBBACCF3B0'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = 'Evernote*'
  silentArgs     = '/S'
  validExitCodes = @(0, 3010, -1073741819)
}

Install-ChocolateyPackage @packageArgs
