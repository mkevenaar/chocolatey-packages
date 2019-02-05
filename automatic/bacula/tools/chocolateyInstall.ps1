$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.bacula.org/download/7459/'
$checksum32     = '9b3e56294286f8acd2dd7e79735695505708000ebb6c543866efc65c1357f6e4'
$checksumType32 = 'sha256'
$url64          = 'https://www.bacula.org/download/7461/'
$checksum64     = '9cc164840b74f6bb32d09eb08c5bd80640ce47f23eaf601c00a9bfb47ea7a6ec'
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

