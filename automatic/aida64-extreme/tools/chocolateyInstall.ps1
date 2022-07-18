$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://download.aida64.com/aida64extreme675.exe'
$checksum     = '12d2a102cbdb8f8bf35164ef98d531c34b70f24fd4edac7ed32d657687fb8826'
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

