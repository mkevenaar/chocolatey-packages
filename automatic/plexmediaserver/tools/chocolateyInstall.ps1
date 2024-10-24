$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.41.1.9057-af5eaea7a/windows/PlexMediaServer-1.41.1.9057-af5eaea7a-x86.exe'
$checksum32     = 'c2e0e5cdff90127560cab9ca6118a0886d2a98673662a2dba10b5edabda4eba1'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.41.1.9057-af5eaea7a/windows/PlexMediaServer-1.41.1.9057-af5eaea7a-x86_64.exe'
$checksum64     = '6b20da09987c55776ea8b656d2576f447b66a868c512dc0fa5ffcff9aa10106e'
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
