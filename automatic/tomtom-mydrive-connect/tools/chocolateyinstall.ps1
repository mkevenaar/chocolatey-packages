$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://cdn.sa.services.tomtom.com/static/sa/Windows/InstallTomTomMyDriveConnect.exe'
$checksum     = 'E2C5614D3AFFAEBBB214AC71C5D8FDA46E9FBAFBC50CCF6528F3F51DB6405E5D'
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

