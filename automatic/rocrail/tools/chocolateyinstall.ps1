$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://wiki.rocrail.net/rocrail-snapshot/history/rocrail-15748-win32.exe'
$checksum32     = '86e475a09cfb9e2381bce834d489274f45f991f7bff5616dfe4f79029197bba4'
$checksumType32 = 'sha256'
$url64          = 'https://wiki.rocrail.net/rocrail-snapshot/history/rocrail-15748-win64.exe'
$checksum64     = '9b501cc8d7d9cd31ccf6c9095e864763c39b96ada3e7fd93319569d9c68d3811'
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

