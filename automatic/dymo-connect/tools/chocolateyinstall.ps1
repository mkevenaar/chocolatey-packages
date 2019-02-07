$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://download.dymo.com/dymo/Software/Win/DCDSetup1.0.exe'
$checksum     = 'dcd9ee361574518191d45d32252fcc91dd8dcdd0faede29c940efa3eebf06ffd'
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

