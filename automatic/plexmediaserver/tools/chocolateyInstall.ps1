$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.32.8.7639-fb6452ebf/windows/PlexMediaServer-1.32.8.7639-fb6452ebf-x86.exe'
$checksum32     = '69258115fa6e6a91f51f392c1fd1b4e8b002be75e6d92076f7c764eaad19c7b6'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.32.8.7639-fb6452ebf/windows/PlexMediaServer-1.32.8.7639-fb6452ebf-x86_64.exe'
$checksum64     = '199dfd86946f7ad956314f272700007f4127f27e821298acfd752120f5765ea9'
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
