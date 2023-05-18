$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://cdn.sa.services.tomtom.com/static/sa/Windows/InstallTomTomMyDriveConnect.exe'
$checksum     = '893D5EDD9CD4562418A21F984881B71DE344AECD01B3F40DEF110BDE0D1A9C6A'
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

