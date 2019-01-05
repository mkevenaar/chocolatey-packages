$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://blog.bacula.org/download/6558/'
$checksum32     = 'cf12b01e6396eade478a82b3b6b7c9903b36bbce935fab161e7811326a76afc1'
$checksumType32 = 'sha256'
$url64          = 'https://blog.bacula.org/download/6560/'
$checksum64     = '34a3cc1d538601f58aca74ecc9f808f53aaa59072e7abe2140a217f2655f7dbf'
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

