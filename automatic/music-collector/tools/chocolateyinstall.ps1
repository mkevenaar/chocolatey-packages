$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://installers.collectorz.com/music-win/musiccollectorsetup2111.exe'
$checksum     = '2bd9f5904434414c38cf93f9411a8972f9dd3cc7ed5e7f55ffd52159f38ad153'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType      = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName  = 'Music Collector*'
  silentArgs    = "/VERYSILENT /NORESTART /RESTARTEXITCODE=3010 /SP- /SUPPRESSMSGBOXES /CLOSEAPPLICATIONS /FORCECLOSEAPPLICATIONS"
  validExitCodes= @(0,3010)
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs

