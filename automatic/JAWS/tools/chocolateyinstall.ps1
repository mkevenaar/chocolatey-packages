$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://jaws2020.vfo.digital/2020.1912.11.400/EAFCB36D-67FA-4B8D-838F-B6F6624F08A7/J2020.1912.11.400-Offline-x86.exe'
$checksum32     = '18d3ada8540230624f681caacd329ca268c7854282b7e46fb2d6392b2245d9b2'
$checksumType32 = 'sha256'
$url64          = 'http://jaws2020.vfo.digital/2020.1912.11.400/EAFCB36D-67FA-4B8D-838F-B6F6624F08A7/J2020.1912.11.400-Offline-x64.exe'
$checksum64     = 'be57d4984673764856357d9080595761dbf428031ee2fc380e4d3100d36cbd4e'
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

