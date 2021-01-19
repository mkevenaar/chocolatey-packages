$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://jaws2021.vfo.digital/2021.2012.57.400/4AD070D7-B284-424D-97A4-85ACBB926A1E/J2021.2012.57.400-Offline-x86.exe'
$checksum32     = '5b5d2e7456edd30b353ba2d1bb7dc8461818373bad422e9d5e1729387c730a8e'
$checksumType32 = 'sha256'
$url64          = 'https://jaws2021.vfo.digital/2021.2012.57.400/4AD070D7-B284-424D-97A4-85ACBB926A1E/J2021.2012.57.400-Offline-x64.exe'
$checksum64     = 'e67676fb27128960f363d7470be2f18403e44f23feace5ac1ac0aabda64669c5'
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

