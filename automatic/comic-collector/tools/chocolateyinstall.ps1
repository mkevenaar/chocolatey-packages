$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://installers.collectorz.com/comic-win/comiccollectorsetup2044.exe'
$checksum     = 'be73d91d2ca82eae71189eed513cb2df428a09511fcc488a75f2d3185a718441'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType      = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName  = 'Comic Collector*'
  silentArgs    = "/VERYSILENT /NORESTART /RESTARTEXITCODE=3010 /SP- /SUPPRESSMSGBOXES /CLOSEAPPLICATIONS /FORCECLOSEAPPLICATIONS"
  validExitCodes= @(0,3010)
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs

