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
$checksum     = '09C84168CBC5230EE2FABD7CE0DEE03A15F2228931850F82EDD46F82857B8015'
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
