$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://cdn.sa.services.tomtom.com/static/sa/Windows/InstallTomTomMyDriveConnect.exe'
$checksum     = 'E21E324D27C0F364B946B4DA9325B282606D4EF42AF7DD38FBF0B346F3FC0BDF'
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

