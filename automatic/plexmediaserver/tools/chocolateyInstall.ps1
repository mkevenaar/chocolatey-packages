$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.31.3.6868-28fc46b27/windows/PlexMediaServer-1.31.3.6868-28fc46b27-x86.exe'
$checksum32     = '7ac608e31c7853f6abfd7e62ee4bc1843a178f68e2b602b6091d0180ca014b1b'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.31.3.6868-28fc46b27/windows/PlexMediaServer-1.31.3.6868-28fc46b27-x86_64.exe'
$checksum64     = '2fc819be3241fd9e9afe247d0ec7f86f5ab201a935cb110bd08a06c68395acf8'
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
