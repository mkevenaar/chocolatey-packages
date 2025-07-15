$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.41.9.9961-46083195d/windows/PlexMediaServer-1.41.9.9961-46083195d-x86.exe'
$checksum32     = '37bfb8ab9579740419a037e2df1589b21ac26d76249889e38b3efcc35ba160dd'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.41.9.9961-46083195d/windows/PlexMediaServer-1.41.9.9961-46083195d-x86_64.exe'
$checksum64     = 'b351f77bf95608e2b1474a5bf68ff723c3e5c53315d2070404496db5572a4a83'
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
