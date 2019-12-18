$ErrorActionPreference = 'Stop'

$osInfo = Get-WmiObject Win32_OperatingSystem | Select-Object Version, ProductType, Caption, OperatingSystemSKU, BuildNumber

Write-host "Detected:  $($osInfo.Caption)" -ForegroundColor Cyan

$osInfo.Version = [version]$osInfo.Version
if ($osInfo.Version -lt [version]'6.1') {
   Throw 'Evernote requires Windows 7 or later.'
}
elseif ($osInfo.ProductType -ne 1) {
   Throw 'Evernote cannot be installed on Windows Server.'
}

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://cdn1.evernote.com/win6/public/Evernote_6.22.3.8816.exe'
$checksum     = '9975de88d73efe05dc7170f6498f9da1ee8669d1ee97c0f447761a8548316207'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = 'Evernote*'
  silentArgs     = '/quiet'
  validExitCodes= @(0,3010,-1073741819)
}

Install-ChocolateyPackage @packageArgs
