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
$checksum     = 'A5D1EBD780C5A3C76AA9A16FC6238EF96F139A5970FE8CFBDE1A3278571430FA'
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
