$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://download.aida64.com/aida64extreme625.exe'
$checksum     = '9b5eeb953bd5eb187500ddaafc5cea7294fbcc536ebb588f18214a1d86e5f2c0'
$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
  softwareName  = 'AIDA64 Extreme*'
  silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0,3010)
}

Install-ChocolateyPackage @packageArgs

