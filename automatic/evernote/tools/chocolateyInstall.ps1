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
$url          = 'https://cdn1.evernote.com/boron/win/builds/Evernote-10.61.5-win-ddl-stage-20230831054637-ce5a1255fff78e49e8a7bdf417e8f4e2deaac541-setup.exe'
$checksum     = 'ca43b07cd279a7366df649cbd21d9b0b74dcc76729efae500b2148fffb1141ed'
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
  validExitCodes= @(0,3010,-1073741819)
}

Install-ChocolateyPackage @packageArgs
