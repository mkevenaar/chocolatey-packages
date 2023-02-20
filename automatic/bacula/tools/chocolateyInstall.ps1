$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.bacula.org/download/11249/'
$checksum32     = 'dbc5b2706ccd401ef677cbfc87afafe6b38e128d7aa30f70f0620e2fb79f9f9e'
$checksumType32 = 'sha256'
$url64          = 'https://www.bacula.org/download/11251/'
$checksum64     = 'a8773a83c4d47251ad5ca51f49d090a99923bb462257e79df2ccc56ba78d8fa6'
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

