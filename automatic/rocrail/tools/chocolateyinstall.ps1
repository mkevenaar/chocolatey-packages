$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://wiki.rocrail.net/rocrail-snapshot/history/rocrail-14943-win32.exe'
$checksum32     = 'aab000bd09818acd1dff92d25d4a31575c6ed4283b454095fdfada25a36e292d'
$checksumType32 = 'sha256'
$url64          = 'https://wiki.rocrail.net/rocrail-snapshot/history/rocrail-14943-win64.exe'
$checksum64     = 'f011744fb043d660d1569c6373e47b33eb37d38a1d459d25bc8535e1829d7ccd'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName  = 'Rocrail*'
  silentArgs    = "/VERYSILENT /NORESTART /RESTARTEXITCODE=3010 /SP- /SUPPRESSMSGBOXES /CLOSEAPPLICATIONS /FORCECLOSEAPPLICATIONS"
  validExitCodes= @(0,3010)
}

Install-ChocolateyPackage @packageArgs

