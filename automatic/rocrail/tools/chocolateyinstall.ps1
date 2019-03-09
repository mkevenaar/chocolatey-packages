$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://wiki.rocrail.net/rocrail-snapshot/history/rocrail-15166-win32.exe'
$checksum32     = '60d23c21ffcdb67b32c43fc5a412cd29190e074629aab81cce93bffe53f22fad'
$checksumType32 = 'sha256'
$url64          = 'https://wiki.rocrail.net/rocrail-snapshot/history/rocrail-15166-win64.exe'
$checksum64     = '0503a6439fef670a45d9b34a488774f8b16e086065c70f3e23c7079af33db9f4'
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

