$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.32.3.7162-b0a36929b/windows/PlexMediaServer-1.32.3.7162-b0a36929b-x86.exe'
$checksum32     = 'b06eff30e575bbbf5f4cdd6ecf7c31075eb6b043f9bdb5783895ef3b74e72831'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.32.3.7162-b0a36929b/windows/PlexMediaServer-1.32.3.7162-b0a36929b-x86_64.exe'
$checksum64     = '0a191f57a992492494343dc4da933705019f156a912a18d6d0faf60508630a0c'
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
