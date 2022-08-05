$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.bacula.org/download/11148/'
$checksum32     = '0ab4c00c02e01903320bcac6f7caf8abee58b01888c1ea67bcd05a751fa4ffe6'
$checksumType32 = 'sha256'
$url64          = 'https://www.bacula.org/download/11150/'
$checksum64     = 'b78d492d2d60fe206b9d9478099b33a7e928f65e36b7d686eedfad2e17900621'
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

