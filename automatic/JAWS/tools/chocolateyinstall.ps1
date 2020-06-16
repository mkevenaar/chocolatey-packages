$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://jaws2020.vfo.digital/2020.2006.12.400/54A46703-8BC3-43F2-8CD1-EED20B3D9DC7/J2020.2006.12.400-Offline-x86.exe'
$checksum32     = '520d4c516078e26f38126dc01dd1eb66c6b17d5be0c06a7c227a60899d96ba0a'
$checksumType32 = 'sha256'
$url64          = 'http://jaws2020.vfo.digital/2020.2006.12.400/54A46703-8BC3-43F2-8CD1-EED20B3D9DC7/J2020.2006.12.400-Offline-x64.exe'
$checksum64     = 'ee693b0455b067ee5d7dab3888f2640de25b7383596b39bd6375ff19ef1723a4'
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

