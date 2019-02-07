$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://cdn.sa.services.tomtom.com/static/sa/Windows/InstallTomTomMyDriveConnect.exe'
$checksum     = 'BA15CA09F1EE72103D379AECA2F670F7CBA5210187D67131E72D8F09A0A7F74C'
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

