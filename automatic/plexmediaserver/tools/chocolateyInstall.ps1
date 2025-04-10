$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.41.6.9685-d301f511a/windows/PlexMediaServer-1.41.6.9685-d301f511a-x86.exe'
$checksum32     = '9f34fd267bc2d01881c8774bda9d825b30624764f49775c6ff82f1840a52a33b'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.41.6.9685-d301f511a/windows/PlexMediaServer-1.41.6.9685-d301f511a-x86_64.exe'
$checksum64     = 'e85acff38763bf9a64a545529d19455b485eee9a980e310f9b15a529956585a5'
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
