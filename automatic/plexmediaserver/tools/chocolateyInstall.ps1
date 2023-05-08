$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.32.1.6999-91e1e2e2c/windows/PlexMediaServer-1.32.1.6999-91e1e2e2c-x86.exe'
$checksum32     = 'ca9d0f126453ad5507a1d99df80c9834deb657fc05933526613e7ef9fe3256b5'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.32.1.6999-91e1e2e2c/windows/PlexMediaServer-1.32.1.6999-91e1e2e2c-x86_64.exe'
$checksum64     = '6708fdd10a6cbda9fedaa3f28156719b3efe7e9c10ff6b7bcad67e3b38df8449'
$checksumType64 = 'sha256'

Start-CheckandStop "Plex Media Server"

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
  softwareName  = 'plexmediaserver*'
  silentArgs    = '/quiet /VERYSILENT'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

if ($ProcessWasRunning -eq "True") {&$ProcessFullPath}
