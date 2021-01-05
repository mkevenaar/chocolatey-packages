$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://jaws2021.vfo.digital/2021.2012.48.400/45BB6725-2B67-4D7E-899B-7E00BCF529F4/J2021.2012.48.400-Offline-x86.exe'
$checksum32     = '1e39ad17cc1ef01deb7b7480ffec4c1e38706eda132732b8c4ac5310d5f6d459'
$checksumType32 = 'sha256'
$url64          = 'https://jaws2021.vfo.digital/2021.2012.48.400/45BB6725-2B67-4D7E-899B-7E00BCF529F4/J2021.2012.48.400-Offline-x64.exe'
$checksum64     = '9f86c3726817b01ed01c9f15fca6c9ec8803ca08b71c985e788cb5b68353b537'
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

