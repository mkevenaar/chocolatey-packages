$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.bacula.org/download/10451/'
$checksum32     = '3d7aa03a855d7cbf590a934286234796d7db0c2dd29235b13e9cbc2cd2a138a5'
$checksumType32 = 'sha256'
$url64          = 'https://www.bacula.org/download/10453/'
$checksum64     = '758ec0961bd462df1e180eb4cdda024d12b2d86f986ffbcd66d0336495cf540d'
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

