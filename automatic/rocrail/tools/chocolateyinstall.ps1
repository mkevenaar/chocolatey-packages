$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://wiki.rocrail.net/rocrail-snapshot/history/rocrail-15100-win32.exe'
$checksum32     = '4101c7d06f19ce45f0547d3294bd1c64e8b00913e2fbbcf183e9b6f3e149be5b'
$checksumType32 = 'sha256'
$url64          = 'https://wiki.rocrail.net/rocrail-snapshot/history/rocrail-15107-win64.exe'
$checksum64     = '4fc6cb3cbe7967213956006ba098b915028430e08c25b85bfd477f088e4ca99e'
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

