$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.dymo.com/dymo/Software/Win/DLS8Setup8.7.4.exe'
$checksum     = '409d79f053ba0c803ce83b71e8245992cd63708fa27017f48a5063826f1bea4d'
$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'DYMO Label*'
  fileType      = 'exe'
  silentArgs    = "/S /V`"/qn /norestart`""
  validExitCodes= @(0,1641,3010)
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
