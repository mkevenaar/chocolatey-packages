$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.bacula.org/download/10590/'
$checksum32     = 'c342f7b68239506b1e292560b3611ad614d073f07c92f589116f2b601e02637d'
$checksumType32 = 'sha256'
$url64          = 'https://www.bacula.org/download/10592/'
$checksum64     = '4b5b998046a61287838d5ced374e0ba15c2f89be1ea9cf32d4b7d0697f24a64e'
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

