$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://cdn.sa.services.tomtom.com/static/sa/Windows/InstallTomTomMyDriveConnect.exe'
$checksum     = '67A3A6BB0DB14F014B3EDB0EC94B41965FE89EAE2ECF1F33CDE35741BFB95C3F'
$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType      = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName  = 'TomTom MyDrive Connect*'
  silentArgs    = "/S"
  validExitCodes= @(0,3010)
}

Install-ChocolateyPackage @packageArgs

