$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.41.3.9292-bc7397402/windows/PlexMediaServer-1.41.3.9292-bc7397402-x86.exe'
$checksum32     = '0c66d445723878d7bdf967ea4f227d24206d91fefe98a8d34e60a6f50e05c85c'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.41.3.9292-bc7397402/windows/PlexMediaServer-1.41.3.9292-bc7397402-x86_64.exe'
$checksum64     = '9e1fd7de83b5457cb66ba7d0ec7f8cb10e3ba62938d0ac9509c9c7095367b1bc'
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
