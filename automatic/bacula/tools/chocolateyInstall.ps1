$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.bacula.org/download/9916/'
$checksum32     = '528c3d2950d0fca0a0e54b2cba0db3d7dcb2d7103864755324030e841a528d4f'
$checksumType32 = 'sha256'
$url64          = 'https://www.bacula.org/download/9918/'
$checksum64     = 'f6ffe867044eb5daa950234e4ce63cc2c250aecb5a50ea0d9f50771b55877763'
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

