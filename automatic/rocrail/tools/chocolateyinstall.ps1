$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://wiki.rocrail.net/rocrail-snapshot/history/rocrail-356-win32.exe'
$checksum32     = '4d00ba5091fa3299c86fdddbfb59e9289ed72c19ddc94c3f45ba0c56acd5d55f'
$checksumType32 = 'sha256'
$url64          = 'https://wiki.rocrail.net/rocrail-snapshot/history/rocrail-356-win64.exe'
$checksum64     = 'e264268d44735a4b0c898b92dd9a5a09bd2fb0bfc72a2d0cdc99dfe0a1d32995'
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

