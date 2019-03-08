$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://download.dymo.com/dymo/Software/Win/DCDSetup1.0.1.exe'
$checksum     = 'b5c2bcadc77268643bfa1b450f47d47307779b3a759d78d202be3797fce8ce76'
$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'DYMO Connect*'
  fileType      = 'exe'
  silentArgs    = "/s /v`"/qn`" /v`"REBOOT=ReallySuppress`" /sms"
  validExitCodes= @(0,1641,3010)
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs

