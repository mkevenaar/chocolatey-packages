$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.bacula.org/download/10847/'
$checksum32     = 'ceb4402aaba5bc1ecdfb9a2ddb05d9f5860a1e8d001b43a6adde3c1a338c72b8'
$checksumType32 = 'sha256'
$url64          = 'https://www.bacula.org/download/10850/'
$checksum64     = 'bb7059b208a48aea292047e252247d1ec1190bc9ae69e236727344c5bc8760b0'
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

