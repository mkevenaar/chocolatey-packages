# https://www.plex.tv/media-server-downloads/#plex-app
$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64       = 'https://downloads.plex.tv/plexmediaplayer/2.58.0.1076-38e019da/PlexMediaPlayer-2.58.0.1076-38e019da-windows-x64.exe'
$checksum64  = '208fd446410174aae17acb12c89940c92589ea75ed18db967e027ab2b3e4648b'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName  = 'Plex Media Player' 
  silentArgs    = '/S'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
