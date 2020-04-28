$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://jaws2020.vfo.digital/2020.2004.66.400/FAE8BEBF-943F-4773-8446-17D7524E0F16/J2020.2004.66.400-Offline-x86.exe'
$checksum32     = '948dca8d2ed14e12401a2d42281f3e1d215a2b8a2c13c3464ee90178676236cb'
$checksumType32 = 'sha256'
$url64          = 'http://jaws2020.vfo.digital/2020.2004.66.400/FAE8BEBF-943F-4773-8446-17D7524E0F16/J2020.2004.66.400-Offline-x64.exe'
$checksum64     = 'ce28fef3381f00fcd41ac1320c4a71950ebe27dce3326dc5e4120d3e9cc3c4b0'
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

