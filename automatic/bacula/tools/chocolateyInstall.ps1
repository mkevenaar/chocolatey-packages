$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.bacula.org/download/11119/'
$checksum32     = '7aca733f28ff8a55c98f4758863d7e76e29a4889e4c0a749e05ff9083a797cb8'
$checksumType32 = 'sha256'
$url64          = 'https://www.bacula.org/download/11121/'
$checksum64     = 'f1fd1788be17d300b0d52eae2354ea32f35aff07c3305ef46d1a1d75315faa0e'
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

