$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://jaws2021.vfo.digital/2021.2102.34.400/B5613A9C-761C-4E09-9133-D05A4B49119A/J2021.2102.34.400-Offline-x86.exe'
$checksum32     = '8db7759145ddb6e1003522e0cf6d805810586b743435a167067559d659243732'
$checksumType32 = 'sha256'
$url64          = 'https://jaws2021.vfo.digital/2021.2102.34.400/B5613A9C-761C-4E09-9133-D05A4B49119A/J2021.2102.34.400-Offline-x64.exe'
$checksum64     = 'ff911765cbc0cb069a68599fa0481b8d4896b412d72e9a68bd6bff907e914773'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName  = 'Freedom Scientific JAWS 2020*'
  silentArgs    = "/Type Silent"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

