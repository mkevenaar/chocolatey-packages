$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.32.4.7195-7c8f9d3b6/windows/PlexMediaServer-1.32.4.7195-7c8f9d3b6-x86.exe'
$checksum32     = '85b67822f5adb73a4041b8f0c13d39c21bf9526c19f706f28020aaa315b5ad0e'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.32.4.7195-7c8f9d3b6/windows/PlexMediaServer-1.32.4.7195-7c8f9d3b6-x86_64.exe'
$checksum64     = '5b88d41d207bcf97b864f7ccf935ac46ce07cfa45edfd333845c6b9849405087'
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
