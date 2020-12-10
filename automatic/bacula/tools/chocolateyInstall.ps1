$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.bacula.org/download/10513/'
$checksum32     = '6335974aa9c95fadb7aa38baecfb26df587ad4317d902aed65183d3ee7b21149'
$checksumType32 = 'sha256'
$url64          = 'https://www.bacula.org/download/10517/'
$checksum64     = '60fff959fa9dca8d28d59b6bc17035d66e39e30d15191f2d36ba026831c5f87b'
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
  softwareName  = 'Bacula*'
  silentArgs    = '/S'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

