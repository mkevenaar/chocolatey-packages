$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.41.7.9823-59f304c16/windows/PlexMediaServer-1.41.7.9823-59f304c16-x86.exe'
$checksum32     = '0c9e9a74a6baf86720f8ac4cbf9c5d43fa81276ac36cfbd09f0afcc4510d5e39'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.41.7.9823-59f304c16/windows/PlexMediaServer-1.41.7.9823-59f304c16-x86_64.exe'
$checksum64     = '07e292f206ff4d31e1fd2ab00aad87eed7c7fae9c37c0732b2e38ae3771e452e'
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
