$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://download.dymo.com/dymo/Software/Win/DLS8Setup.8.7.3.exe'
$checksum     = 'd7b55a5e1431d5b44241bee91d1841a5cd1990480dfcb73c9f80f57dc6b9c803'
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
